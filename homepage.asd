;;;; homepage.asd

(asdf:defsystem #:homepage
  :serial t
  :description "Describe homepage here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:hunchentoot #:cl-who #:parenscript)
  :components ((:file "package")
               (:file "homepage")
               (:file "pages")))

