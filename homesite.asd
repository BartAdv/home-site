;;;; homesite.asd

(asdf:defsystem #:homesite
  :serial t
  :description "Describe homesite here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:hunchentoot #:cl-who #:parenscript)
  :components ((:file "package")
               (:file "site")
               (:file "pages")))

