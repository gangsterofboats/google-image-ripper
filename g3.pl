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
use JSON;
use LWP;
use List::MoreUtils 'uniq';
use XML::LibXML;
use feature 'say';

say "@ARGV";
my $filename = join("-", @ARGV) . '.html';
my $search = join("+", @ARGV);

open(my $fh, '>', $filename);
say $fh '<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>';
say $fh "<br>";

for (my $i = 0; $i <= 400; $i += 20)
{
    my $url = "https://www.google.com/search?q=$search&safe=off&tbm=isch&ijn=0&start=$i";
    my $ua = LWP::UserAgent->new;
    my $content = $ua->get($url, 'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36')->content;
    my $doc = XML::LibXML->load_html(string => $content, recover => 2);
    my @images = $doc->findnodes('//*[contains(@class, "rg_meta")]');
    foreach (@images)
    {
        my %nosj = %{decode_json $_->to_literal()};
        my $egami = $nosj{'ou'};
        say $fh "<img src=\"$egami\">";
    }
}
close $fh;

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
