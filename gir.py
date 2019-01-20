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
import re
import requests
import sys

print(' '.join(sys.argv[1:]))
fnam = '-'.join(sys.argv[1:]) + '.html'
srch = '+'.join(sys.argv[1:])

fh = open(fnam, 'w')
fh.write('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>')
fh.write('\n<br>\n')

for i in range(0, 120, 20):
    url = f'https://www.google.com/search?q={srch}&safe=off&tbm=isch&ijn=0&start={i}'
    headers = {'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36'}
    content = requests.get(url, headers=headers).text
    content = re.sub('<', '\n<', content)
    contlines = content.split('\n')
    contlines = [x for x in contlines if '"ou"' in x]
    for s in contlines:
        s = re.sub('.*ou":', '<img src=', s)
        s = re.sub(',"ow.*', '>', s)
        fh.write(f'{s}\n')
fh.close()

f = open(fnam, 'r').read().split('\n')
fo = list(dict.fromkeys(f))
ofh = open(fnam, 'w')
for item in fo:
    ofh.write(f'{item}\n')
ofh.close()
