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

(define (execute-search uri)
  (define content (port->string (get-pure-port (string->url uri))))
  (set! content (string-replace content "<" "\n<"))
  (define contlines (string-split content "\n"))
  (set! contlines (filter (lambda (s) (string-contains? s "imgurl")) contlines))
  (values contlines))

(define (generate-uri search opts extended start)
  (define uri (format "https://www.google~a/search?q=~a&safe=off&tbm=isch" (hash-ref opts 'location) search))
  (cond
    [(and (hash-has-key? opts 'size) (hash-has-key? opts 'time)) (set! uri (string-append uri (format "&tbs=~a,~a" (hash-ref opts 'size) (hash-ref opts 'time))))]
    [(hash-has-key? opts 'size) (set! uri (string-append uri (format "&tbs=~a" (hash-ref opts 'size))))]
    [(hash-has-key? opts 'time) (set! uri (string-append uri (format "&tbs=~a" (hash-ref opts 'time))))])
  (set! uri (string-append uri (format "&ijn=~a&start=~a" extended start)))
  (values uri))

(define options (make-hash))
(hash-set! options 'amount 100)
(hash-set! options 'location ".com")
(define search
  (command-line
   #:program "gir"
   #:once-each
   [("-a" "--amount") amt "Amount of images to search" (hash-set! options 'amount (string->number amt))]
   [("-e" "--extended") "Extended search" (hash-set! options 'extended #t)]
   [("-l" "--location") lctn "The ccTLD" (hash-set! options 'location lctn)]
   [("-s" "--size") sz "Desired image size" (hash-set! options 'size sz)]
   [("-t" "--time") tm "Desired time range" (hash-set! options 'time tm)]
   [("-u" "--uniquify") "Uniquify lines in file result" (hash-set! options 'uniquify #t)]
   #:args srch
   srch))

(displayln (string-join search " "))
(define fnam (string-append (string-join search "-") ".html"))
(define srch (string-join search "+"))

(display-to-file "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>" fnam #:exists 'replace)
(display-to-file "\n<br>\n" fnam #:exists 'append)
(if (hash-has-key? options 'extended)
    (for ([i (in-range 0 (+ (hash-ref options 'amount) 20) 20)])
      (for ([j (in-range 0 10)])
        (define uri (generate-uri srch options j i))
        (define contlines (execute-search uri))
        (for ([item contlines])
          (set! item (regexp-replace #rx".*imgurl=" item "<img src=\""))
          (set! item (regexp-replace #rx"&amp.*" item "\">"))
          (display-to-file (format "~a~n" item) fnam #:exists 'append))))
    (for ([i (in-range 0 (+ (hash-ref options 'amount) 20) 20)])
      (define uri (generate-uri srch options 0 i))
      (define contlines (execute-search uri))
      (for ([item contlines])
        (set! item (regexp-replace #rx".*imgurl=" item "<img src=\""))
        (set! item (regexp-replace #rx"&amp.*" item "\">"))
        (display-to-file (format "~a~n" item) fnam #:exists 'append))))

(cond
  [(hash-has-key? options 'uniquify)
   (define fs (file->string fnam))
   (define fo (string-split fs "\n"))
   (set! fo (remove-duplicates fo))
   (display-lines-to-file fo fnam #:exists 'replace)])
