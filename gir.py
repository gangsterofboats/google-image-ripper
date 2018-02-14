#!/usr/bin/python
import sys
import re
import requests

print ' '.join(sys.argv[1:])
fnam = '-'.join(sys.argv[1:])
srch = '+'.join(sys.argv[1:])
fnam = fnam + '.html'
fh = open(fnam, 'w')
fh.write('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>')
fh.write('\n<br>\n')
for i in range(0, 420, 20):
    url = 'https://www.google.com/search?q={}&safe=off&tbm=isch&ijn=0&start={}'.format(srch, i)
    content = requests.get(url).text
    content = re.sub('<', '\n<', content)
    contlines = content.split('\n')
    contlines = [x for x in contlines if 'imgurl' in x]
    for s in contlines:
        s = re.sub('.*imgurl=', '<img src="', s)
        s = re.sub('&amp.*', '">', s)
        fh.write(s)
        fh.write('\n')
fh.close()
