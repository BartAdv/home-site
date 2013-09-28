;;;; package.lisp

(in-package #:cl-user)

(defpackage #:site
  (:use #:cl #:hunchentoot #:cl-who #:parenscript)
  (:export :define-script
           :define-html))

(defpackage #:site-pages
  (:use #:cl #:site #:parenscript))
