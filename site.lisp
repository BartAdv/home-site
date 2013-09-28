;;;; site.lisp

(in-package #:site)

;;; "site" goes here. Hacks and glory await!

;;; let's see!

(defvar *web-server* (make-instance 'easy-acceptor :port 4242))
(hunchentoot:start *web-server*)

(push (create-folder-dispatcher-and-handler "/static/" #p"/homesite/") *dispatch-table*)

(define-easy-handler (site-module :uri "/app.js") ()
  (setf (content-type*) "text/javascript")
  (ps (chain angular
             (module "homesite" (array))
             (config (array "$routeProvider" 
                            (lambda($routeProvider) 
                              (chain $routeProvider 
                                     (when "/pages" (create 'template-url "/pages/index.html" :controller 'pages-ctrl)))))))))

(define-easy-handler (get-post :uri "/") ()
                     (with-html-output-to-string 
                       (*standard-output* nil :indent t)
                       (:html :ng-app "homesite"
                         (:head
                           (:title "Under construction"))
                           (:script :src "https://ajax.googleapis.com/ajax/libs/angularjs/1.0.8/angular.min.js")
                           (:script :src "/app.js")
                           (:script :src "/pages/script.js")
                         (:body
                           (:div :ng-view "")))))
