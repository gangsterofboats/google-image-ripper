#!/usr/bin/env julia
using Requests

println(join(ARGS, " "))
fnam = join(ARGS, "-")
srch = join(ARGS, "+")
fnam = fnam * ".html"

open(fnam, "w") do fh
    write(fh, "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>")
    write(fh, "\n<br>\n")

    for i in 0:20:400
        uri = "https://www.google.com/search?q=$srch&safe=off&tbm=isch&ijn=0&start=$i"
        cnt = get(uri)
        content = String(map((c) -> Char(c), cnt.data))
        content = replace(content, "<", "\n<")
        contlines = split(content, "\n")
        cntlines = filter((l) -> contains(l, "imgurl"), contlines)
        for l in cntlines
            l = replace(l, r".*imgurl=", "<img src=\"")
            l = replace(l, r"&amp.*", "\">")
            write(fh, l)
            write(fh, "\n")
        end
    end
end
