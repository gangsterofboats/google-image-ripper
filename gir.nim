#!/usr/bin/env nim
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

import os, strutils, httpclient, sequtils, re

var args = commandLineParams()
echo join(args, " ")
var fileName = join(args, "-") & ".html"
var searchTerm = join(args, "+")

var fh = open(fileName, fmWrite)
fh.writeLine("<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>")
fh.writeLine("<br>")

for i in countup(0,100,20):
  var client = newHttpClient()
  var content = client.getContent("http://www.google.com/search?q=$1&safe=off&tbm=isch&ijn=0&start=$2" % [searchTerm, intToStr(i)])
  content = content.replace("<", "\n<")
  var contlines = splitlines(content)
  contlines = filter(contlines, proc(x: string): bool = x.find("imgurl") != -1)
  for line in mitems(contlines):
    line = line.replace(re".*imgurl=", "<img src=\"")
    line = line.replace(re"&amp.*", "\">")
    fh.writeLine(line)

fh.close()

var fs = readFile(fileName)
var fo = splitLines(fs)
fo = deduplicate(fo)
fs = join(fo, "\n")
writeFile(fileName, fs)
