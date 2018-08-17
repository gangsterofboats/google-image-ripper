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

my @f = $filename.IO.lines(:chomp);
my @fo = @f.unique;
spurt $filename, @fo.join("\n");
