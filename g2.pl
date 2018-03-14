#!/usr/bin/perl
use strict;
use warnings;
use LWP;
use Getopt::Long;

GetOptions(
    'amount|a=i' => \(my $amount = 8000),
    'extended|e' => \my $extended,
    'location|l=s' => \(my $location = '.com'),
    'size|s=s' => \my $size,
    'time|t=s' => \my $time
);
my %options = ( amount => $amount, extended => $extended, location => $location, size => $size, time => $time );

sub execute_search
{
    my $uri = shift;
    my $ua = LWP::UserAgent->new;
    my $content = $ua->get($uri, 'User-Agent' => 'rmccurdy.com')->content;
    $content =~ s/</\n</g;
    my @contlines = split("\n", $content);
    @contlines = grep(/imgurl/, @contlines);
 
    return @contlines;
}
    
sub generate_uri
{
    my $search = shift;
    my %options = %{shift()};
    my $extended = shift;
    my $start = shift;

    my $uri = "https://www.google$options{location}/search?q=$search&safe=off&tbm=isch";

    if ($options{size} and $options{time})
    {
        $uri .= "&tbs=$options{size},$options{time}";
    }
    elsif ($options{size})
    {
        $uri .= "&tbs=$options{size}";
    }
    elsif ($options{time})
    {
        $uri .= "&tbs=$options{time}";
    }

    $uri .= "&ijn=$extended&start=$start";

    return $uri;
}

print "@ARGV\n";
my $filename = join("-", @ARGV);
my $search = join("+", @ARGV);
$filename .= '.html';

open(my $fh, '>', $filename);
print $fh '<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>';
print $fh "\n<br>\n";

if ($options{extended})
{
    for (my $j = 0; $j <= 9; $j++)
    {
        for (my $i = 0; $i <= $options{amount}; $i += 20)
        {
            my $uri = generate_uri($search, \%options, $j, $i);
            my @contlines = execute_search($uri);
            foreach (@contlines)
            {
                $_ =~ s/.*imgurl=/<img src="/;
                $_ =~ s/&amp.*/">/;
                print $fh "$_\n";
            }
        }
    }
}
else
{
    for (my $i = 0; $i <= $options{amount}; $i += 20)
    {
        my $uri = generate_uri($search, \%options, 0, $i);
        my @contlines = execute_search($uri);
        foreach (@contlines)
        {
            $_ =~ s/.*imgurl=/<img src="/;
            $_ =~ s/&amp.*/">/;
            print $fh "$_\n";
        }
    }
    
}

close $fh;
