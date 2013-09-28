;;;; package.lisp

(in-package #:cl-user)

(defpackage #:pretty-literals)

(defpackage #:site
  (:use #:cl 
        #:pretty-literals 
        #:hunchentoot 
        #:cl-who 
        #:parenscript 
        #:cl-json)
  (:shadowing-import-from #:parenscript :prototype)
  (:export :define-script
           :define-html
           :define-resource))

(defpackage #:site-pages
  (:use #:cl #:pretty-literals #:site #:parenscript))
