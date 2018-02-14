#!/usr/bin/crystal
require "uri"
require "http/client"

puts ARGV.join(" ")
fnam = ARGV.join("-")
srch = ARGV.join("+")
fnam += ".html"

fh = File.new fnam, "w"
fh.puts "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>"
fh.puts "<br>"

(0..100).step(20) do |i|
  uri = URI.parse "http://www.google.com/search?q=#{srch}&safe=off&tbm=isch&ijn=0&start=#{i}"
  response = HTTP::Client.get uri
  content = response.body
  content = content.gsub("<", "\n<")
  contlines = content.split("\n")
  contlines = contlines.grep(/imgurl/)
  contlines.each do |item|
    item = item.gsub(/.*imgurl=/, "<img src=\"")
    item = item.gsub(/&amp.*/, "\">")
    fh.puts item
  end
end

fh.close
