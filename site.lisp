;;;; site.lisp

(in-package #:site)

;;; "site" goes here. Hacks and glory await!

;;; let's see!

(defvar *web-server* (make-instance 'easy-acceptor :port 4242))
(hunchentoot:start *web-server*)

(push (create-folder-dispatcher-and-handler "/static/" #p"~/content/") *dispatch-table*)

(defmacro define-script ((name uri) &body script)
  `(define-easy-handler (,name :uri ,uri) ()
     (setf (content-type*) "text/javascript")
     (ps ,@script)))

(defmacro define-html ((name uri) &body html)
  `(define-easy-handler (,name :uri ,uri) ()
     (setf (content-type*) "text/html")
     (with-html-output-to-string (*standard-output* nil :indent t)
       ,@html)))

(defmacro define-resource ((name uri) &body body)
  `(define-easy-handler (,name :uri ,uri) ()
     (setf (content-type*) "application/json")
     (with-output-to-string (s) (encode-json ,@body s))))

(define-script (site-module "/app.js")
  (chain angular
         (module "homesite" (array))
         (config (array "$routeProvider" 
                        (lambda($routeProvider) 
                          (chain $routeProvider 
                                 (when "/pages" (create 'template-url "/pages/index.html" :controller 'pages-ctrl))))))))

(define-html (get-post "/")
  (:html :ng-app "homesite"
   (:head
     (:title "Under construction"))
   (:script :src "https://ajax.googleapis.com/ajax/libs/angularjs/1.0.8/angular.min.js")
   (:script :src "/app.js")
   (:script :src "/pages/script.js")
   (:body
     (:div :ng-view ""))))

