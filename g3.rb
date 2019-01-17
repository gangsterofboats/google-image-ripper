#!/usr/bin/env ruby
####################################################################################
# Google Image Ripper - compile links from Google image searches into an HTML file #
# Copyright (C) 2019 Michael Wiseman                                               #
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
require 'json'
require 'nokogiri'

puts ARGV.join(' ')
file_name = ARGV.join('-') + '.html'
search = ARGV.join('+')

fh = File.open(file_name, 'w+')
fh.puts('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>')
fh.puts('<br>')

http = HTTP.headers('User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36')
(0..400).step(20) do |i|
  uri = "https://www.google.com/search?q=#{search}&safe=off&tbm=isch&tbs=isz:lt,islt:2mp&ijn=0&start=#{i}"
  # uri = "https://www.google.com/search?q=#{search}&safe=off&tbm=isch&ijn=0&start=#{i}"
  content = http.get(uri).to_s
  doc = Nokogiri::HTML(content)
  images = doc.css('.rg_meta')
  images.each do |img|
    nosj = JSON.parse(img.text)
    egami = nosj['ou']
    fh.puts("<img src=\"#{egami}\">")
  end
end
fh.close

fo = File.readlines(file_name)
fo.uniq!
File.open(file_name, 'w+') do |fi|
  fo.each {|item| fi.puts("#{item}")}
end
