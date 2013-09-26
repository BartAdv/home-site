;;;; homepage.lisp

(in-package #:homepage)

;;; "homepage" goes here. Hacks and glory await!

;;; let's see!

(defvar *web-server* (make-instance 'easy-acceptor :port 4242))
(hunchentoot:start *web-server*)

(push (create-folder-dispatcher-and-handler "/static/" #p"/homepage/") *dispatch-table*)

(define-easy-handler (get-post :uri "/") ()
                     (with-html-output-to-string (*standard-output* nil :indent t)
                       (:html
                         (:head
                           (:title "Under construction"))
                         (:body
                           (:p "Hello")))))
