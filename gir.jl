#!/usr/bin/env julia
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

using HTTP

println(join(ARGS, " "))
fnam = join(ARGS, "-")
srch = join(ARGS, "+")
fnam = fnam * ".html"

open(fnam, "w") do fh
    write(fh, "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>")
    write(fh, "\n<br>\n")

    for i in 0:20:100
        uri = "https://www.google.com/search?q=$srch&safe=off&tbm=isch&ijn=0&start=$i"
        r = HTTP.request("GET", uri)
        content = String(r.body)
        content = replace(content, "<", "\n<")
        contlines = split(content, "\n")
        contlines = filter((l) -> contains(l, r"imgurl"), contlines)
        for l in contlines
            l = replace(l, r".*imgurl=", "<img src=\"")
            l = replace(l, r"&amp.*", "\">")
            write(fh, l)
            write(fh, "\n")
        end
    end
end

fo = readlines(fnam)
fo = unique(fo)
open(fnam, "w") do ofh
    for ln in fo
        write(ofh, ln)
        write(ofh, "\n")
    end
end
