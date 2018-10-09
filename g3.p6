#!/usr/bin/env perl6
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

use HTML::Parser::XML;
use HTTP::UserAgent;

say @*ARGS.join(' ');
my $filename = join("-", @*ARGS) ~ '.html';
my $search = join("+", @*ARGS);

my $fh = open $filename, :w;
$fh.say('<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>');
$fh.say('<br>');

loop (my $i = 0; $i <= 100; $i += 20)
{
    my $url = "http://www.google.com/search?q=$search&safe=off&tbm=isch&ijn=0&start=$i";
    my $ua = HTTP::UserAgent.new;
    my $parser = HTML::Parser::XML.new;
    my $response = $ua.get($url);
    $parser.parse($response.content);
    my @images = $parser.xmldoc.elements(:class(* eq 'rg_l'), :RECURSE);
    for @images
    {
        $_ = $_.Str.subst(/.*imgurl\=/, '<img src="');
        $_ = $_.Str.subst(/\&amp.*/, '">');
        $fh.say("$_");
    }
}
$fh.close;

# my @f = $filename.IO.lines(:chomp);
# my @fo = @f.unique;
# spurt $filename, @fo.join("\n");
