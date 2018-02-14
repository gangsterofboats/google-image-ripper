#!/usr/bin/ruby
require 'net/http'
require 'uri'

puts ARGV.join(' ')
fnam = ARGV.join('-')
srch = ARGV.join('+')
fnam += '.html'

fh = open(fnam, 'w')
fh.write('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>')
fh.write("\n<br>\n")

(0..400).step(20) do |i|
  uri = URI.parse("https://www.google.com/search?q=#{srch}&safe=off&tbm=isch&ijn=0&start=#{i}")
  content = Net::HTTP.get_response(uri).body
  content.gsub!(/</, "\n<")
  contlines = content.split("\n")
  contlines = contlines.grep(/imgurl/)
  contlines.each do |item|
    item.gsub!(/.*imgurl=/, '<img src="')
    item.gsub!(/&amp.*/, '">')
    fh.write("#{item}\n")
  end
end

fh.close
