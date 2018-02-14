#!/usr/bin/tclsh
package require http

puts $argv
set fnam [join $argv "-"]
set srch [join $argv "+"]
append fnam ".html"
puts $fnam

set fh [open $fnam "w"]
puts $fh "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>"
puts $fh "<br>"
for {set i 0} {$i <= 400} {incr i 20} {
    set uri "http://www.google.com/search?q=$srch&safe=off&tbm=isch&ijn=0&start=$i"
    set tkn [::http::geturl $uri]
    set content [::http::data $tkn]
    set content [string map {< \n<} $content]
    set contlines [split $content "\n"]
    set contlines [lsearch -all -inline -regexp $contlines "imgurl"]
    foreach item $contlines {
        regsub -all {.*imgurl=} $item "<img src=\"" item
        regsub -all {&amp.*} $item "\">" item
        puts $fh $item
    }
}
close $fh
