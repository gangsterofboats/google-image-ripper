#!/bin/csh
# echo "$*"
echo "$argv[*]"
set fnam=`echo "$*" | tr " " "-"`
set srch=`echo "$*" | tr " " "+"`
echo '<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>' > "$fnam".html
echo '<br>' >> "$fnam".html

foreach i (`seq 0 20 1000`)
    curl -s -A 'rmccurdy.com' "https://www.google.com/search?q=$srch&safe=off&tbm=isch&ijn=0&start=$i" | awk '{gsub("<","\n<"); print}' | grep imgurl | sed -e 's/.*imgurl=/<img src="/' -e 's/&amp.*/">/' >> "$fnam".html
end
#ijn = something to do with google ajax
