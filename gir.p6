#!/usr/bin/perl6
use LWP::Simple;

say @*ARGS.join(' ');
my $filename = join("-", @*ARGS);
my $search = join("+", @*ARGS);
$filename ~= '.html';
my $fh = open $filename, :w;
$fh.say('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>');
$fh.say('<br>');
loop (my $i = 0; $i <= 400; $i += 20)
{
    my $url = "http://www.google.com/search?q=$search&safe=off&tbm=isch&ijn=0&start=$i";
    my $content = LWP::Simple.new.get($url, { "User-Agent" => "rmccurdy.com" });
    $content .= subst(/\</, "\n<", :g);
    my @contlines = split("\n", $content);
    @contlines = grep /imgurl/, @contlines;
    for @contlines
    {
        $_ .= subst(/.*imgurl\=/, '<img src="');
        $_ .= subst(/\&amp.*/, '">');
        $fh.say("$_");
    }
}
$fh.close;
