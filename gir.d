import std.stdio;
import std.array;
import std.range;
import std.format;
import std.net.curl;
import std.string;
import std.algorithm;
import std.regex;
import std.conv;

void main(string[] args)
{
    writeln(args[1..$].join(" "));
    string fnam = args[1..$].join("-");
    string srch = args[1..$].join("+");
    fnam = fnam ~ ".html";

    File fh = File(fnam, "w");
    fh.writeln("<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>");
    fh.writeln("<br>");
    foreach (i; iota(0, 420, 20))
    {
        string uri = format("https://www.google.com/search?q=%s&safe=off&tbm=isch&ijn=0&start=%s", srch, i); 
        auto content = get(uri);
        content = content.replace("<", "\n<");
        auto contlines = splitLines(content);
        auto cntlns = filter!(line => indexOf(line, "imgurl") != -1) (contlines[]);
        auto riuis = regex(r".*imgurl=");
        auto rsc = regex(r"&amp.*");
        foreach (item; cntlns)
        {
            item = replaceAll(item, riuis, "<img src=\"");
            item = replaceAll(item, rsc, "\">");
            fh.writeln(item);
        }
    }
    fh.close();
}
