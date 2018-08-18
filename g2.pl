#!/usr/bin/env perl
####################################################################################
# Google Image Ripper - compile links from Google image searches into an HTML file #
# Copyright (C) 2018 Michael Wiseman                                               #
#                                                                                  #
# This program is free software: you can redistribute it and/or modify it under    #
# the terms of the GNU General Public License as published by the Free Software    #
# Foundation, either version 3 of the License, or (at your option) any later       #
# version.                                                                         #
#                                                                                  #
# This program is distributed in the hope that it will be useful, but WITHOUT ANY  #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A  #
# PARTICULAR PURPOSE.  See the GNU General Public License for more details.        #
#                                                                                  #
# You should have received a copy of the GNU General Public License along with     #
# this program.  If not, see <https://www.gnu.org/licenses/>.                      #
####################################################################################

use strict;
use warnings;
use Getopt::Long;
use List::MoreUtils 'uniq';
use LWP;
use feature 'say';

GetOptions(
    'amount|a=i' => \(my $amount = 8000),
    'extended|e' => \my $extended,
    'location|l=s' => \(my $location = '.com'),
    'size|s=s' => \my $size,
    'time|t=s' => \my $time,
    'uniquify|u' => \my $uniquify
);
my %options = ( amount => $amount, extended => $extended, location => $location, size => $size, time => $time, uniquify => $uniquify );

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

say "@ARGV";
my $filename = join("-", @ARGV);
my $search = join("+", @ARGV);
$filename .= '.html';

open(my $fh, '>', $filename);
say $fh '<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>';
say $fh "<br>";

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
                say $fh "$_";
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
            say $fh "$_";
        }
    }

}
close $fh;

if ($options{uniquify})
{
    open(my $ifh, '<', $filename);
    my @f = <$ifh>;
    close $ifh;
    chomp(@f);
    my @fo = uniq @f;

    open(my $ofh, '>', $filename);
    foreach (@fo)
    {
        say $ofh "$_";
    }
    close $ofh;
}
