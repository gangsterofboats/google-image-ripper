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

import os, strutils, httpclient, sequtils, re, tables, strformat, parseopt

proc executeSearch(uri: string): seq[string] =
  var client = newHttpClient()
  var content = client.getContent(uri)
  content = content.replace("<", "\n<")
  var contlines = splitlines(content)
  contlines = filter(contlines, proc(x: string): bool = x.find("imgurl") != -1)

  return contlines

proc generateUri(search: string, options: var Table, extended, start: int): string =
  var uri = "http://www.google$1/search?q=$2&safe=off&tbm=isch" % [options["location"], search]

  if (options["size"] != "" and options["time"] != ""):
    uri = uri & "&tbs=$1,$2" % [options["size"], options["time"]]
  elif (options["size"] != ""):
    uri = uri & "&tbs=$1" % [options["size"]]
  elif (options["time"] != ""):
    uri = uri & "&tbs=$1" % [options["time"]]

  uri = uri & fmt"&ijn={extended}&start={start}"

  return uri

var options = {"amount": "100", "extended": "", "location": ".com", "size": "", "time": "", "uniquify": ""}.toTable
var args: seq[string]
args = @[]
for kind, key, value in getOpt():
  case kind
  of cmdArgument:
    args.add(key)
  of cmdLongOption, cmdShortOption:
    case key
    of "amount", "a": options["amount"] = value
    of "extended", "e": options["extended"] = "true"
    of "location", "l": options["location"] = value
    of "size", "s": options["size"] = value
    of "time", "t": options["time"] = value
    of "uniquify", "u": options["uniquify"] = "true"
    else: discard
  of cmdEnd: discard

echo join(args, " ")
var fileName = join(args, "-") & ".html"
var searchTerm = join(args, "+")

var fh = open(fileName, fmWrite)
fh.writeLine("<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>")
fh.writeLine("<br>")

if options["extended"] == "true":
  for i in countup(0,parseInt(options["amount"]),20):
    for j in countup(0,9):
      var uri = generateUri(searchTerm, options, j, i)
      var contlines = executeSearch(uri)
      for line in mitems(contlines):
        line = line.replace(re".*imgurl=", "<img src=\"")
        line = line.replace(re"&amp.*", "\">")
        fh.writeLine(line)
else:
  for i in countup(0,parseInt(options["amount"]),20):
    var uri = generateUri(searchTerm, options, 0, i)
    var contlines = executeSearch(uri)
    for line in mitems(contlines):
      line = line.replace(re".*imgurl=", "<img src=\"")
      line = line.replace(re"&amp.*", "\">")
      fh.writeLine(line)
fh.close()

if options["uniquify"] = "true":
    var fs = readFile(fileName)
    var fo = splitLines(fs)
    fo = deduplicate(fo)
    fs = join(fo, "\n")
    writeFile(fileName, fs)
