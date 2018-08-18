#!/usr/bin/env elixir
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

args = Enum.join(System.argv(), " ")
IO.puts "#{args}"
srch = Enum.join(System.argv(), "+")
fnam = Enum.join(System.argv(), "-")
fnam = fnam <> ".html"

File.write(fnam, "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>", [:write])
File.write(fnam, "\n<br>\n", [:append])

:inets.start
:ssl.start
for i <- Enum.take_every(0..100, 20) do
    uri = 'https://www.google.com/search?q=#{srch}&safe=off&tbm=isch&ijn=0&start=#{i}'
    {_, {{_, _, _}, _, body}} = :httpc.request(uri)
    body = to_string body
    body = String.replace(body, "<", "\n<")
    content = String.split(body, "\n")
    content = Enum.filter(content, fn(item) -> String.contains? item, "imgurl" end)
    for line <- content do
      line = Regex.replace(~r/.*imgurl=/, line, "<img src=\"")
      line = Regex.replace(~r/&amp.*/, line, "\">")
      File.write(fnam, line, [:append])
      File.write(fnam, "\n", [:append])
    end
end
:ssl.stop
:inets.stop

fs = File.read! fnam
fo = String.split(fs, "\n")
fo = Enum.uniq(fo)
fs = Enum.join(fo, "\n")
File.write(fnam, fs)
