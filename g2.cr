#!/usr/bin/env crystal
# require 'net/http'
# require 'addressable/uri'
require "uri"
require "http/client"
require "option_parser"

options = {} of Symbol => String
OptionParser.parse! do |opts|
  opts.banner = "Usage: g2.cr [options] search-term"

  options[:amount] = "8000"
  opts.on("-a", "--amount AMOUNT", "Amount of images to search") { |a| options[:amount] = a }

  opts.on("-e", "--extended", "Extended search") { options[:extended] = "true" }

  options[:location] = ".com"
  opts.on("-l", "--location LOCATION", "The ccTLD") { |l| options[:location] = l }

  opts.on("-s", "--size SIZE", "Desired image size") { |s| options[:size] = s }

  opts.on("-t", "--time TIME", "Desired time range") { |t| options[:time] = t }
  # opts.on("-u", "--uniquify", "Uniquify lines in file result") { options[:uniquify] = true }
end

def execute_search(uri)
  puri = URI.parse uri
  response = HTTP::Client.get puri
  content = response.body
  content = content.gsub("<", "\n<")
  contlines = content.split("\n")
  contlines = contlines.grep(/imgurl/)

  return contlines
end

def generate_uri(search, options, extended, start)
  uri = "https://www.google#{options[:location]}/search?q=#{search}&safe=off&tbm=isch"

  if options.has_key?(:size) && options.has_key?(:time)
    uri += "&tbs=#{options[:size]},#{options[:time]}"
  elsif options.has_key?(:size)
    uri += "&tbs=#{options[:size]}"
  elsif options.has_key?(:time)
    uri += "&tbs=#{options[:time]}"
  end

  uri += "&ijn=#{extended}&start=#{start}"

  return uri
end

arg = ARGV.join(" ")
puts arg
fnam = ARGV.join("-")
srch = ARGV.join("+")
fnam += ".html"

fh = File.new fnam, "w"
fh.puts "<!DOCTYPE html>\n<html>\n<head>\n<title>#{arg}</title>\n</head>\n<body>"
fh.puts "<h1>NOTICE: NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>"
fh.puts "<br>"

if options.has_key?(:extended)
  (0..options[:amount].to_i).step(20) do |i|
    (0..9).each do |j|
      uri = generate_uri(srch, options, j, i)
      contlines = execute_search(uri)
      contlines.each do |item|
        item = item.gsub(/.*imgurl=/, "<img src=\"")
        item = item.gsub(/&amp.*/, "\">")
        fh.puts item
      end
    end
  end
else
  (0..options[:amount].to_i).step(20) do |i|
    uri = generate_uri(srch, options, 0, i)
    contlines = execute_search(uri)
    contlines.each do |item|
      item = item.gsub(/.*imgurl=/, "<img src=\"")
      item = item.gsub(/&amp.*/, "\">")
      fh.puts item
    end
  end
end

fh.puts "</body>\n</html>"
fh.close
