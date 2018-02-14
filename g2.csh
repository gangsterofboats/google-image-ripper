#!/bin/csh
# amount extneded location size time
set opts=(`getopt -s tcsh -o a:el:s:t: -l amount:,extended,location:,size:,time: -- $argv:q`)
eval set argv=\($opts:q\)
while (1)
    switch ($1:q)
    case -a:
    case --amount:
        set amt=$2; shift; shift
        breaksw
    case -e:
    case --extended:
        set extd=true; shift
        breaksw
    case -l:
    case --location:
        set lct=$2; shift; shift
        breaksw
    case -s:
    case --size:
        set sz=$2; shift; shift
        breaksw
    case -t:
    case --time:
        set tm=$2; shift; shift
        breaksw
    case --:
        shift
        break
    default:
        echo "Usage: g2 [-a AMOUNT] [-e] [-l LOCATION] [-s SIZE] [-t TIME] search"
        exit 1
    endsw
end

# Echo search and set search and filename variables
echo "$argv"
set fnam=`echo "$argv[*]" | tr " " "-"`
set srch=`echo "$*" | tr " " "+"`

# Generate URI
if (! $?lct) then
    set lct='.com'
endif
set uri="https://www.google$lct/search?q=$srch&safe=off&tbm=isch"
if ($?sz && $?tm) then
    set uri="$uri&tbs=$sz,$tm"
else if ($?sz) then
    set uri="$uri&tbs=$sz"
else if ($?tm) then
    set uri="$uri&tbs=$tm"
endif

if (! $?amt) then
    set amt=100
endif

# Main program

echo '<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>' > "$fnam".html
echo '<br>' >> "$fnam".html

if ($?extd) then
    foreach i (`seq 0 20 $amt`)
        foreach j (`seq 0 9`)
            set ou="$uri"
            set uri="$uri&ijn=$j&start=$i"
            curl -s -A 'rmccurdy.com' "$uri" | awk '{gsub("<","\n<"); print}' | grep imgurl | sed -e 's/.*imgurl=/<img src="/' -e 's/&amp.*/">/' >> "$fnam".html
            set uri="$ou"
        end
    end
else
    foreach i (`seq 0 20 $amt`)
        set ou="$uri"
        set uri="$uri&ijn=0&start=$i"
        curl -s -A 'rmccurdy.com' "$uri" | awk '{gsub("<","\n<"); print}' | grep imgurl | sed -e 's/.*imgurl=/<img src="/' -e 's/&amp.*/">/' >> "$fnam".html
        set uri="$ou"
    end
endif
#ijn = something to do with google ajax
