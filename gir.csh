#!/usr/bin/csh
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

echo "$argv[*]"
set fnam=`echo "$*" | tr " " "-"`
set srch=`echo "$*" | tr " " "+"`
echo '<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>' > "$fnam".html
echo '<br>' >> "$fnam".html

foreach i (`seq 0 20 100`)
    curl -s -A 'rmccurdy.com' "https://www.google.com/search?q=$srch&safe=off&tbm=isch&ijn=0&start=$i" | gawk '{gsub("<","\n<"); print}' | grep imgurl | sed -e 's/.*imgurl=/<img src="/' -e 's/&amp.*/">/' >> "$fnam".html
end

mv "$fnam".html "$fnam".html.bak
cat "$fnam".html.bak | uniq > "$fnam".html
rm "$fnam".html.bak
