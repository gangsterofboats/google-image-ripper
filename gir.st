#!/usr/bin/gst -f
" #################################################################################### "
" # Google Image Ripper - compile links from Google image searches into an HTML file # "
" # Copyright (C) 2018 Michael Wiseman                                               # "
" #                                                                                  # "
" # This program is free software: you can redistribute it and/or modify it under    # "
" # the terms of the GNU General Public License as published by the Free Software    # "
" # Foundation, either version 3 of the License, or (at your option) any later       # "
" # version.                                                                         # "
" #                                                                                  # "
" # This program is distributed in the hope that it will be useful, but WITHOUT ANY  # "
" # WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A  # "
" # PARTICULAR PURPOSE.  See the GNU General Public License for more details.        # "
" #                                                                                  # "
" # You should have received a copy of the GNU General Public License along with     # "
" # this program.  If not, see <https://www.gnu.org/licenses/>.                      # "
" #################################################################################### "
PackageLoader fileInPackage: 'NetClients'.

arg := (Smalltalk arguments join: ' ').
arg displayNl.
search := Smalltalk arguments join: '+'.
fname := (Smalltalk arguments join: '-'),'.html'.
fh := FileStream open: fname mode: FileStream write.
fh nextPutAll: '<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>'; nl.
fh nextPutAll: '<br>'; nl.

0 to: 100 by: 20 do: [ :i |
  uri := 'http://www.google.com/search?q=',search,'&safe=off&tbm=isch&ijn=0&start=',(i printString).
  cnts := (FileStream open: uri mode: FileStream read) contents asString.
  cnts := cnts replacingAllRegex: '<' with: (String with: Character nl),'<'.
  contlines := cnts tokenize: (String with: Character nl).
  contlines := contlines collect: [:each | (each matchRegex: '.*imgurl.*') ifTrue: [each]].
  contlines do: [:each | each ifNotNil:
                              [item := each replacingAllRegex: '.*imgurl=' with: '<img src="'.
                               item := item replacingAllRegex: '&amp.*' with: '">'.
                               fh nextPutAll: item; nl.]
  ]
]
