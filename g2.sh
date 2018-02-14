#!/bin/sh

while getopts ":a:el:s:t:" opt; do
    case $opt in
        a)
            amt=${OPTARG}
            ;;
        l)
            lct=${OPTARG}
            ;;
        e)
            extd=true
            ;;
        s)
            sz=${OPTARG}
            ;;
        t)
            tm=${OPTARG}
            ;;
        \?)
            echo "Usage: g2 [-a AMOUNT] [-e] [-l LOCATION] [-s SIZE] [-t TIME] search"
            ;;
    esac
done
shift $((OPTIND -1))

generate_uri ()
{
    if [ -z "$lct" ]
    then
        lct='.com'
    fi
    
    uri="https://www.google$lct/search?q=$srch&safe=off&tbm=isch"

    if [ -n "$sz" ] && [ -n "$tm" ]
    then
        uri=$uri"&tbs=$sz,$tm"
    elif [ -n "$sz" ]
    then
        uri=$uri"&tbs=$sz"
    elif [ -n "$tm" ]
    then
        uri=$uri"&tbs=$tm"
    fi

    echo $uri
}

echo "$@"
fnam=$(echo $* | tr " " "-")
srch=$(echo $* | tr " " "+")
url=$(generate_uri)

echo '<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>' > "$fnam".html
echo '<br>' >> "$fnam".html

if [ -z $amt ]
then
    amt=8000
fi

if [ $extd ]
then
    for i in $(seq 0 20 $amt)
    do
        for j in $(seq 0 9)
        do
            ou=$url
            url=$url"&ijn=$j&start=$i"
            curl -s -A 'rmccurdy.com' "$url" | awk '{gsub("<","\n<"); print}' | grep imgurl | sed -e 's/.*imgurl=/<img src="/' -e 's/&amp.*/">/' >> "$fnam".html
            url=$ou
        done
    done
else
    for i in $(seq 0 20 $amt)
    do
        ou=$url
        url=$url"&ijn=0&start=$i"
        curl -s -A 'rmccurdy.com' "$url" | awk '{gsub("<","\n<"); print}' | grep imgurl | sed -e 's/.*imgurl=/<img src="/' -e 's/&amp.*/">/' >> "$fnam".html
        url=$ou
    done
fi
