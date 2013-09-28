;;;; homesite.asd

(asdf:defsystem #:homesite
  :serial t
  :description "Describe homesite here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:hunchentoot #:cl-who #:parenscript #:cl-json)
  :components ((:file "package")
               (:file "pretty-literals")
               (:file "site")
               (:file "pages")))

