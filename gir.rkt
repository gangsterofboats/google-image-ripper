#lang racket
#|
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
|#

(require net/url)

(displayln (string-join (vector->list (current-command-line-arguments)) " "))
(define fnam (string-append (string-join (vector->list (current-command-line-arguments)) "-") ".html"))
(define srch (string-join (vector->list (current-command-line-arguments)) "+"))

(display-to-file "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>" fnam #:exists 'replace)
(display-to-file "\n<br>\n" fnam #:exists 'append)
(for ([i (in-range 0 120 20)])
  (define uri (format "https://www.google.com/search?q=~a&safe=off&tbm=isch&ijn=0&start=~a" srch i))
  (define content (port->string (get-pure-port (string->url uri))))
  (set! content (string-replace content "<" "\n<"))
  (define contlines (string-split content "\n"))
  (set! contlines (filter (lambda (s) (string-contains? s "imgurl")) contlines))
  (for ([item contlines])
    (set! item (regexp-replace #rx".*imgurl=" item "<img src=\""))
    (set! item (regexp-replace #rx"&amp.*" item "\">"))
    (display-to-file (format "~a~n" item) fnam #:exists 'append)))

(define fs (file->string fnam))
(define fo (string-split fs "\n"))
(set! fo (remove-duplicates fo))
(display-lines-to-file fo fnam #:exists 'replace)
