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
fnam = ARGV.join('-') + '.html'
srch = ARGV.join('+')

fh = File.open(fnam, 'w+')
fh.write('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>')
fh.write("\n<br>\n")

(0..400).step(20) do |i|
  uri = "https://www.google.com/search?q=#{srch}&safe=off&tbm=isch&ijn=0&start=#{i}"
  http = HTTP.headers('User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36')
  content = http.get(uri).to_s
  content.gsub!(/</, "\n<")
  contlines = content.split("\n")
  contlines = contlines.grep(/"ou"/)
  contlines.each do |item|
    item.gsub!(/.*ou":/, '<img src=')
    item.gsub!(/,"ow.*/, '>')
    fh.write("#{item}\n")
  end
end
fh.close

fo = File.readlines(fnam)
fo.uniq!
File.open(fnam, 'w+') do |fi|
  fo.each { |item| fi.write("#{item}") }
end
