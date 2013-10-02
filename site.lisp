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

(defmacro define-resource ((name uri &rest args) &body body)
  (let ((args (when (not (null args)) args)))
  `(define-easy-handler (,name :uri ,uri) ,args
     (setf (content-type*) "application/json")
     (with-output-to-string (s) (encode-json ,@body s)))))

(define-script (site-module "/app.js")
  (chain angular
         (module "homesite" (array "pages"))
         (directive "toMarkdown" (lambda ()
                                   (create :restrict "A"
                                           :scope (create :text "=")
                                           :controller (lambda ($scope $element)
                                                         (chain $scope ($watch "text" (lambda () (if (@ $scope text) (chain $element (html (chain markdown (to-H-T-M-L (@ $scope text)))))))))))))

         (config (array "$routeProvider" 
                        (lambda($routeProvider) 
                          (chain $routeProvider 
                                 (when "/pages" (create 'template-url "/pages/index.html" :controller 'pages-ctrl))
                                 (when "/page/:id" (create 'template-url "/pages/view.html" :controller 'page-ctrl))))))))

(define-html (get-root "/")
  (:html :ng-app "homesite"
   (:head
     (:title "Under construction"))
   (:script :src "https://ajax.googleapis.com/ajax/libs/angularjs/1.0.8/angular.min.js")
   (:script :src "https://ajax.googleapis.com/ajax/libs/angularjs/1.0.8/angular-resource.min.js")
   (:script :src "/static/markdown.min.js")
   (:script :src "/app.js")
   (:script :src "/pages/script.js")
   (:body
     (:div :ng-view ""))))

