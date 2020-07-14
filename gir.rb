#!/usr/bin/env ruby
####################################################################################
# Google Image Ripper - compile links from Google image searches into an HTML file #
# Copyright (C) 2018 Michael Wiseman                                               #
#                                                                                  #
# This program is free software: you can redistribute it and/or modify it under    #
# the terms of the GNU General Public License as published by the Free Software    #
# Foundation, either version 3 of the License, or (at your option) any later       #
# version.                                                                         #
#                                                                                  #
# This program is distributed in the hope that it will be useful, but WITHOUT ANY  #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A  #
# PARTICULAR PURPOSE.  See the GNU General Public License for more details.        #
#                                                                                  #
# You should have received a copy of the GNU General Public License along with     #
# this program.  If not, see <https://www.gnu.org/licenses/>.                      #
####################################################################################
require 'http'

puts ARGV.join(' ')
arg = ARGV.join(' ')
filename = ARGV.join('-') + '.html'
search = ARGV.join('+')

fh = File.open(filename, 'w+')
fh.write("<!DOCTYPE html>\n<html>\n<head>\n<title>#{arg}</title>\n</head>\n<body>\n")
fh.write("<h1>#{arg}</h1>")
fh.write("\n<br>\n")
fh.write('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>')
fh.write("\n<br>\n")

(0..100).each do |i|
  # uri = "https://www.google.com/search?q=#{search}&safe=off&tbm=isch&ijn=#{i}"
  uri = "https://www.google.com/search?q=#{search}&safe=off&tbm=isch&tbs=isz:lt,islt:2mp&ijn=#{i}"
  # uri = "https://www.google.com/search?q=#{search}&safe=off&tbm=isch&tbs=qdr:y,isz:lt,islt:2mp&ijn=#{i}"
  http = HTTP.headers('User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36')
  content = http.get(uri).to_s
  content.gsub!(/</, "\n<")
  contlines = content.split("\n")
  contlines = contlines.grep(/^,\[\"http/)
  contlines.each do |item|
    item.gsub!(/^,\[/, '<img src=')
    item.gsub!(/\",.*$/, '">')
    fh.write("#{item}\n")
  end
end
fh.write("</body>\n</html>")
fh.close

fo = File.readlines(filename)
fo.uniq!
File.open(filename, 'w+') do |fi|
  fo.each { |item| fi.write("#{item}") }
end
