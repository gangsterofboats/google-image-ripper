const fs = require('fs');
const https = require('https');

var args = process.argv.slice(2);
console.log(`${args.join(' ')}`);
var fnam = args.join('-');
var srch = args.join('+');
fnam += '.html';

var fh = fs.createWriteStream(fnam, {flags: 'a'});
fh.write('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>');
fh.write("\n<br>\n");
for (var i = 0; i <= 400; i = i + 20)
{
    var uri = `https://www.google.com/search?q=${srch}&safe=off&tbm=isch&ijn=0&start=${i}`;
    https.get(uri, (resp) => {
        let data = '';
        resp.on('data', (chunk) => {
            data += chunk;
        });
        resp.on('end', () => {
            data = data.replace(/</g, "\n<");
            var contlines = data.split("\n");
            contlines = contlines.filter(l => l.indexOf("imgurl") > -1);
            contlines.forEach(function(item) {
                item = item.replace(/.*imgurl=/, '<img src="');
                item = item.replace(/&amp.*/, '">');
                fh.write(`${item}\n`);
            });
        });
    });
}
