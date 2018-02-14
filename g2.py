#!/usr/bin/python

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
# parser.add_argument('-u', '--uniquify',  help='Uniquify lines in output file')
parser.add_argument('search', nargs='+', help='The search to run') # nargs=argparse.REMAINDER
options = parser.parse_args()

def execute_search(uri):
    content = requests.get(uri).text
    content = re.sub('<', '\n<', content)
    contlines = content.split('\n')
    contlines = [x for x in contlines if 'imgurl' in x]

    return contlines

def generate_uri(search, options, extended, start):
    uri = 'https://www.google{}/search?q={}&safe=off&tbm=isch'.format(options.location, search)

    if (options.size and options.time):
        uri = uri + '&tbs={},{}'.format(options.size,options.time)
    elif options.size:
        uri = uri + '&tbs={}'.format(options.size)
    elif options.time:
        uri = uri + '&tbs={}'.format(options.time)

    uri = uri + '&ijn={}&start={}'.format(extended, start)

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
            print(url)
            contlines = execute_search(url)
            for s in contlines:
                s = re.sub('.*imgurl=', '<img src="', s)
                s = re.sub('&amp.*', '">', s)
                fh.write(s)
                fh.write('\n')
else:
    for i in range(0, int(options.amount) + 20, 20):
        url = generate_uri(srch, options, 0, i)
        print(url)
        contlines = execute_search(url)
        for s in contlines:
            s = re.sub('.*imgurl=', '<img src="', s)
            s = re.sub('&amp.*', '">', s)
            fh.write(s)
            fh.write('\n')
fh.close()
