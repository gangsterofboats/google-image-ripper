#!/usr/bin/env Rscript
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

argv <- (commandArgs(TRUE))
args <- paste(argv, collapse=" ")
print(args)
fnam <- paste(argv, collapse="-")
srch <- paste(argv, collapse="+")
fnam <- paste(fnam, ".html", sep="")

fh <- file(fnam, open="w")
writeLines('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>', fh)
writeLines('<br>', fh)

for (i in seq(0, 100, by=20))
{
    uri <- paste("https://www.google.com/search?q=", srch, "&safe=off&tbm=isch&ijn=0&start=", i, sep="")
    content <- readLines(uri)
    content <- gsub("<", "\n<", content)
    contlines <- as.list(strsplit(content, split="\n")[[1]])
    contlines <- contlines[grep("imgurl", contlines)]
    contlines <- gsub(".*imgurl=", '<img src="', contlines)
    contlines <- gsub("&amp.*", '">', contlines)
    writeLines(contlines, fh)
}
close(fh)

fo <- readLines(fnam)
fo <- unique(fo)
writeLines(fo, fnam)
