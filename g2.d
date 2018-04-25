import std.stdio;
import std.array;
import std.range;
import std.format;
import std.net.curl;
import std.string;
import std.algorithm;
import std.regex;
import std.conv;
import std.getopt;

// Two helper functions
auto executeSearch(string uri)
{
    auto content = get(uri);
    content = content.replace("<", "\n<");
    auto contlines = splitLines(content);
    auto cntlns = filter!(line => indexOf(line, "imgurl") != -1) (contlines[]);

    return cntlns;
}

string generateUri(string search, Op otios, int extended, int start)
{
    string uri = format("https://www.google%s/search?q=%s&safe=off&tbm=isch", otios.location, search);

    if (otios.size && otios.time)
    {
        uri = format("%s&tbs=%s,%s", uri, otios.size, otios.time);
    }
    else if (otios.size)
    {
        uri = format("%s&tbs=%s", uri, otios.size);
    }
    else if (otios.time)
    {
        uri = format("%s&tbs=%s", uri, otios.time);
    }

    uri = format("%s&ijn=%s&start=%s", uri, extended, start);

    return uri;
}

// Struct to group getopt arguments
struct Op
{
    int amount = 100;
    bool extended;
    string location = ".com";
    string size;
    string time;
}

void main(string[] args)
{
    Op options;
    getopt(
        args,
        "amount|a", &options.amount,
        "extended|e", &options.extended,
        "location|l", &options.location,
        "size|s", &options.size,
        "time|t", &options.time
    );

    writeln(args[1..$].join(" "));
    string fnam = args[1..$].join("-");
    string srch = args[1..$].join("+");
    fnam = fnam ~ ".html";

    File fh = File(fnam, "w");
    fh.writeln("<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>");
    fh.writeln("<br>");

    if (options.extended)
    {
        foreach(i; iota(0, options.amount + 20, 20))
        {
            foreach(j; iota(0, 10))
            {
                string uri = generateUri(srch, options, j, i);
                auto content = executeSearch(uri);
                auto riuis = regex(r".*imgurl=");
                auto rsc = regex(r"&amp.*");
                foreach (item; content)
                {
                    item = replaceAll(item, riuis, "<img src=\"");
                    item = replaceAll(item, rsc, "\">");
                    fh.writeln(item);
                }
            }
        }
    }
    else
    {
        foreach(i; iota(0, options.amount + 20, 20))
        {
            string uri = generateUri(srch, options, 0, i);
            auto content = executeSearch(uri);
            auto riuis = regex(r".*imgurl=");
            auto rsc = regex(r"&amp.*");
            foreach (item; content)
            {
                item = replaceAll(item, riuis, "<img src=\"");
                item = replaceAll(item, rsc, "\">");
                fh.writeln(item);
            }
        }
    }
    fh.close();
}
