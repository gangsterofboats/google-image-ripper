(quicklisp:quickload "drakma")
(quicklisp:quickload "cl-ppcre")

(format t "~{~a~^ ~}~%" (cdr sb-ext:*posix-argv*))
(defvar fnam (format nil "~{~a~^-~}" (cdr sb-ext:*posix-argv*)))
(defvar srch (format nil "~{~a~^+~}" (cdr sb-ext:*posix-argv*)))
(defparameter fnam (concatenate 'string fnam ".html"))
(with-open-file (fh fnam :direction :output :if-exists :supersede)
  (format fh "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>~%")
  (format fh "<br>~%")
  (loop for i from 0 to 400 by 20 do
	(defparameter url (format nil "https://www.google.com/search?q=~a&safe=off&tbm=isch&ijn=0&start=~d" srch i))
	(defparameter content (drakma:http-request url))
	(defparameter content (cl-ppcre:regex-replace-all "<" content "
	<"))
	(defparameter contlines (cl-ppcre:split "\\n" content))
	(defparameter contlines (remove-if-not #'(lambda (line) (cl-ppcre:scan "imgurl" line)) contlines))
	(map 'list #'(lambda (item) (cl-ppcre:regex-replace-all ".*imgurl=" item "<img src=\"") (cl-ppcre:regex-replace-all "&amp.*" item "\">") (format fh item)) contlines)))
