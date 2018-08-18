#!/usr/bin/env crystal
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

require "uri"
require "http/client"

arg = ARGV.join(" ")
puts arg
fnam = ARGV.join("-")
srch = ARGV.join("+")
fnam += ".html"

fh = File.new fnam, "w"
fh.puts "<!DOCTYPE html>\n<html>\n<head>\n<title>#{arg}</title>\n</head>\n<body>"
fh.puts "<h1>NOTICE: NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>"
fh.puts "<br>"

(0..400).step(20) do |i|
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

fh.puts "</body>\n</html>"
fh.close

f = File.read_lines(fnam)
f.uniq!
ofh = File.open fnam, "w"
f.each { |line| ofh.puts line }
ofh.close
