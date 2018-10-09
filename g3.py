#!/usr/bin/env python
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

import sys
import re
import requests
from bs4 import BeautifulSoup

print(' '.join(sys.argv[1:]))
file_name = '-'.join(sys.argv[1:]) + '.html'
search = '+'.join(sys.argv[1:])

fh = open(file_name, 'w')
fh.write('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>')
fh.write('\n<br>\n')

for i in range(0, 120, 20):
    uri = f'https://www.google.com/search?q={search}&safe=off&tbm=isch&ijn=0&start={i}'
    doc = requests.get(uri).text
    content = BeautifulSoup(doc, 'html.parser')
    images = content.select('.rg_l')
    for line in images:
        img = line['href']
        img = re.sub('.*imgurl=', '<img src="', img)
        img = re.sub('&imgrefurl.*', '">', img)
        fh.write(f'{img}\n')
fh.close()

# f = open(file_name, 'r').read().split('\n')
# fo = list(dict.fromkeys(f))
# ofh = open(file_name, 'w')
# for item in fo:
    # ofh.write(f'{item}\n')
# ofh.close()
