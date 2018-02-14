#!/usr/bin/perl
use strict;
use warnings;
use LWP;

print "@ARGV\n";
my $filename = join("-", @ARGV);
my $search = join("+", @ARGV);
$filename .= '.html';
open(my $fh, '>', $filename);
print $fh '<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>';
print $fh "\n<br>\n";
for (my $i = 0; $i <= 400; $i += 20)
{
    my $url = "https://www.google.com/search?q=$search&safe=off&tbm=isch&ijn=0&start=$i";
    my $ua = LWP::UserAgent->new;
    my $content = $ua->get($url, 'User-Agent' => 'rmccurdy.com')->content;
    $content =~ s/</\n</g;
    my @contlines = split("\n", $content);
    @contlines = grep(/imgurl/, @contlines);
    foreach (@contlines)
    {
        $_ =~ s/.*imgurl=/<img src="/;
        $_ =~ s/&amp.*/">/;
        print $fh "$_\n";
    }
}
close $fh;
