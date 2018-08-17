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
import argparse

parser = argparse.ArgumentParser(description='A Google image search ripper')
parser.add_argument('-a', '--amount', default=8000, help='Amount of images to search')
parser.add_argument('-e', '--extended', action='store_true', help='Extended search')
parser.add_argument('-l', '--location', default='.com', help='The ccTLD')
parser.add_argument('-s', '--size', help='Desired image size')
parser.add_argument('-t', '--time', help='Desired time range')
parser.add_argument('-u', '--uniquify', action='store_true', help='Uniquify lines in output file')
parser.add_argument('search', nargs='+', help='The search to run')
options = parser.parse_args()

def execute_search(uri):
    content = requests.get(uri).text
    content = re.sub('<', '\n<', content)
    contlines = content.split('\n')
    contlines = [x for x in contlines if 'imgurl' in x]
    return contlines

def generate_uri(search, options, extended, start):
    uri = f'https://www.google{options.location}/search?q={search}&safe=off&tbm=isch'

    if (options.size and options.time):
        uri = uri + f'&tbs={options.size},{options.time}'
    elif options.size:
        uri = uri + f'&tbs={options.size}
    elif options.time:
        uri = uri + f'&tbs={options.time}'

    uri = uri + f'&ijn={extended}&start={start}'
    return uri

print(' '.join(options.search))
fnam = '-'.join(options.search)
srch = '+'.join(options.search)
fnam = fnam + '.html'
fh = open(fnam, 'w')
fh.write('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>')
fh.write('\n<br>\n')
if options.extended:
    for i in range(0, int(options.amount) + 20, 20):
        for j in range(0, 10):
            url = generate_uri(srch, options, j, i)
            contlines = execute_search(url)
            for s in contlines:
                s = re.sub('.*imgurl=', '<img src="', s)
                s = re.sub('&amp.*', '">', s)
                fh.write(f'{s}\n')
else:
    for i in range(0, int(options.amount) + 20, 20):
        url = generate_uri(srch, options, 0, i)
        contlines = execute_search(url)
        for s in contlines:
            s = re.sub('.*imgurl=', '<img src="', s)
            s = re.sub('&amp.*', '">', s)
            fh.write(f'{s}\n')
fh.close()

if options.uniquify:
    f = open(fnam, 'r').read().split('\n')
    fo = list(dict.fromkeys(f))
    ofh = open(fnam, 'w')
    for item in fo:
        ofh.write(f'{item}\n')
    ofh.close()
