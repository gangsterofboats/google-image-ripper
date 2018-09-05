;; ####################################################################################
;; # Google Image Ripper - compile links from Google image searches into an HTML file #
;; # Copyright (C) 2018 Michael Wiseman                                               #
;; #                                                                                  #
;; # This program is free software: you can redistribute it and/or modify it under    #
;; # the terms of the GNU General Public License as published by the Free Software    #
;; # Foundation, either version 3 of the License, or (at your option) any later       #
;; # version.                                                                         #
;; #                                                                                  #
;; # This program is distributed in the hope that it will be useful, but WITHOUT ANY  #
;; # WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A  #
;; # PARTICULAR PURPOSE.  See the GNU General Public License for more details.        #
;; #                                                                                  #
;; # You should have received a copy of the GNU General Public License along with     #
;; # this program.  If not, see <https://www.gnu.org/licenses/>.                      #
;; ####################################################################################

(load "/lib/client.arc")

(def gir (arg)
  (prn arg)
  (= search (subst " " "+" arg))
  (= filename (+ (subst " " "-" arg) ".html"))
  (w/outfile fh filename
                (w/stdout fh
                  (prn "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>")
                  (prn "<br>")
                  (= i 0)
                  (until (> i 400)
                         (= uri (+ "https://www.google.com/search?q=" search "&safe=off&tbm=isch&ijn=0&start=" i))
                         (= content (cadr (mkreq uri)))
                         (= content (subst "<" "\n<" content))
                         (= contlines (lines content))
                         (= contlines (keep (fn (_) (posmatch "imgurl" _)) contlines))
                         (forlen i contlines
                                 (= item (contlines i))
                                 (= item (re-subst ".*imgurl=" item "<img src=\""))
                                 (= item (re-subst "&amp.*" item "\">"))
                                 (prn item))
                         (= i (+ i 20))))))
