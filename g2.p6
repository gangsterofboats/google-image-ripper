#!/usr/bin/perl6
use LWP::Simple;

# Sub to execute the search

sub execute-search($uri)
{
    my $content = LWP::Simple.new.get($uri, { "User-Agent" => "rmccurdy.com" });
    $content .= subst(/\</, "\n<", :g);
    my @contlines = split("\n", $content);
    @contlines = grep /imgurl/, @contlines;

    return @contlines;
}

# Sub to generate the uri to get

sub generate-uri($search, %options, $extended, $start)
{
    my $uri = "http://www.google%options<location>/search?q=$search&safe=off&tbm=isch";

    if (%options<size> and %options<time>)
    {
        $uri ~= "&tbs=%options<size>,%options<time>";
    }
    elsif (%options<size>)
    {
        $uri ~= "&tbs=%options<size>";
    }
    elsif (%options<time>)
    {
        $uri ~= "&tbs=%options<time>";
    }

    $uri ~= "&ijn=$extended&start=$start";

    return $uri;
}

# Main function

sub MAIN(Int :a(:$amount) = 8000, Bool :e(:$extended), Str :l(:$location) = '.com', Str :s(:$size), Str :t(:$time), *@search)
{
    my %options = amount => $amount, extended => $extended, location => $location, size => $size, time => $time;
    say "@search[]";
    my $filename = @search.join('-');
    my $srch = @search.join('+');
    $filename ~= '.html';

    my $fh = open $filename, :w;
    $fh.say('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>');
    $fh.say('<br>');

    if (%options<extended>)
    {
        loop (my $i = 0; $i <= %options<amount>; $i += 20)
        {
            loop (my $j = 0; $j <= 9; $j++)
            {
                my $uri = generate-uri($srch, %options, $j, $i);
                my @contlines = execute-search($uri);
                for @contlines
                {
                    $_ .= subst(/.*imgurl\=/, '<img src="');
                    $_ .= subst(/\&amp.*/, '">');
                    $fh.say("$_");
                }
            }
        }
    }
    else
    {
        loop (my $i = 0; $i <= %options<amount>; $i += 20)
        {
            my $uri = generate-uri($srch, %options, 0, $i);
            my @contlines = execute-search($uri);
            for @contlines
            {
                $_ .= subst(/.*imgurl\=/, '<img src="');
                $_ .= subst(/\&amp.*/, '">');
                $fh.say("$_");
            }
        }
    }
    $fh.close;
}
