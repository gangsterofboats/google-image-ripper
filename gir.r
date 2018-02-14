argv <- (commandArgs(TRUE))
args <- paste(argv, collapse=" ")
print(args)
fnam <- paste(argv, collapse="-")
srch <- paste(argv, collapse="+")
fnam <- paste(fnam, ".html", sep="")

fh <- file(fnam, open="a")
writeLines('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>', fh)
writeLines('<br>', fh)

for (i in seq(0, 400, by=20))
{
    uri <- paste("https://www.google.com/search?q=", srch, "&safe=off&tbm=isch&ijn=0&start=", i, sep="")
    content <- readLines(uri)
    content <- gsub("<", "\n<", content)
    contlines <- as.list(strsplit(content, split="\n")[[1]])
    contlines <- contlines[grep("imgurl", contlines)]
    contlines <- gsub(".*imgurl=", '<img src="', contlines)
    contlines <- gsub("&amp.*", '">', contlines)
    write(contlines, fh, append=TRUE)
}
close(fh)
