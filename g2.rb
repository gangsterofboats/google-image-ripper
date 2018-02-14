#!/usr/bin/ruby
require 'net/http'
require 'addressable/uri'
require 'optparse'

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: g3.rb [options] search-term"

  options[:amount] = 8000
  opts.on("-a", "--amount AMOUNT", "Amount of images to search") do |a|
    options[:amount] = a
  end

  opts.on("-e", "--extended", "Extended search") do
    options[:extended] = true
  end

  options[:location] = ".com"
  opts.on("-l", "--location LOCATION", "The ccTLD") do |l|
    options[:location] = l
  end

  opts.on("-s", "--size SIZE", "Desired image size") do |s|
    options[:size] = s
  end

  opts.on("-t", "--time TIME", "Desired time range") do |t|
    options[:time] = t
  end
  # opts.on("-u", "--uniquify", "Uniquify lines in file result") do
    # options[:uniquify] = true
  # end
end

def execute_search(uri)
  puri = Addressable::URI.parse(uri)
  content = Net::HTTP.get_response(puri).body
  content.gsub!(/</, "\n<")
  contlines = content.split("\n")
  contlines = contlines.grep(/imgurl/)

  return contlines
end

def generate_uri(search, options, extended, start)
  uri = "https://www.google#{options[:location]}/search?q=#{search}&safe=off&tbm=isch"

  if (options[:size] and options[:time])
    uri += "&tbs=#{options[:size]},#{options[:time]}"
  elsif options[:size]
    uri += "&tbs=#{options[:size]}"
  elsif options[:time]
    uri += "&tbs=#{options[:time]}"
  end

  uri += "&ijn=#{extended}&start=#{start}"

  return uri
end

optparse.parse!
puts ARGV.join(' ')
fnam = ARGV.join('-')
srch = ARGV.join('+')
fnam += '.html'

fh = open(fnam, 'w')
fh.write('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>')
fh.write("\n<br>\n")

if options[:extended]
  (0..options[:amount].to_i).step(20) do |i|
    (0..9).each do |j|
      uri = generate_uri(srch, options, j, i)
      contlines = execute_search(uri)
      contlines.each do |item|
        item.gsub!(/.*imgurl=/, '<img src="')
        item.gsub!(/&amp.*/, '">')
        fh.write("#{item}\n")
      end
    end
  end
else
  (0..options[:amount].to_i).step(20) do |i|
    uri = generate_uri(srch, options, 0, i)
    contlines = execute_search(uri)
    contlines.each do |item|
      item.gsub!(/.*imgurl=/, '<img src="')
      item.gsub!(/&amp.*/, '">')
      fh.write("#{item}\n")
    end
  end
end

fh.close
