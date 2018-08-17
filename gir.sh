#!/usr/bin/dash
echo "$@"
fnam=$(echo $* | tr " " "-")
srch=$(echo $* | tr " " "+")

echo '<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE' >  "$fnam".html
echo '<br>' >> "$fnam".html

for i in $(seq 0 20 400)
do
    curl -s -A 'rmccurdy.com' "https://www.google.com/search?q=$srch&safe=off&tbm=isch&ijn=0&start=$i" | gawk '{gsub("<","\n<"); print}' | grep imgurl | sed -e 's/.*imgurl=/<img src="/' -e 's/&amp.*/">/' >> "$fnam".html
done
mv "$fnam".html "$fnam".html.bak
cat "$fnam".html.bak | uniq > "$fnam".html
rm "$fnam".html.bak
