#!/usr/bin/env python
####################################################################################
# Google Image Ripper - compile links from Google image searches into an HTML file #
# Copyright (C) 2020 Michael Wiseman                                               #
#                                                                                  #
# This program is free software: you can redistribute it and/or modify it under    #
# the terms of the GNU Affero General Public License as published by the Free      #
# Software Foundation, either version 3 of the License, or (at your option) any    #
# later version.                                                                   #
#                                                                                  #
# This program is distributed in the hope that it will be useful, but WITHOUT ANY  #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A  #
# PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. #
#                                                                                  #
# You should have received a copy of the GNU Affero General Public License along   #
# with this program.  If not, see <https://www.gnu.org/licenses/>.                 #
####################################################################################
import re
import requests
import sys

print(' '.join(sys.argv[1:]))
arg = ' '.join(sys.argv[1:])
file_name = '-'.join(sys.argv[1:]) + '.html'
search = '+'.join(sys.argv[1:])

fh = open(file_name, 'w')
fh.write(f'<!DOCTYPE html>\n<html>\n<head>\n<title>{arg}</title>\n</head>\n<body>\n')
fh.write(f'<h1>{arg}</h1>')
fh.write('\n<br>\n')
fh.write('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>')
fh.write('\n<br>\n')

for i in range(0, 101):
    uri = f'https://www.google.com/search?q={search}&safe=off&tbm=isch&ijn={i}'
    uri = f'https://www.google.com/search?q={search}&safe=off&tbm=isch&tbs=isz:lt,islt:2mp&ijn={i}'
    uri = f'https://www.google.com/search?q={search}&safe=off&tbm=isch&tbs=qdr:y,isz:lt,islt:2mp&ijn={i}'
    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36'}
    doc = requests.get(uri, headers=headers).text
    content = re.sub('<', '\n<', doc)
    contlines = content.split('\n')
    contlines = [x for x in contlines if re.match(r'^,\[\"http', x)]
    for s in contlines:
        s = re.sub(r'^,\[', '<img src=', s)
        s = re.sub(r'",.*$', '">', s)
        fh.write(f'{s}\n')
fh.write('</body>\n</html>')
fh.close()

f = open(file_name, 'r').read().split('\n')
fo = list(dict.fromkeys(f))
ofh = open(file_name, 'w')
for item in fo:
    ofh.write(f'{item}\n')
ofh.close()
