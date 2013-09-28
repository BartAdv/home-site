(in-package :site-pages)

(define-easy-handler (pages-script :uri "/pages/script.js") ()
  (setf (content-type*) "text/javascript")
  (ps (defun pages-ctrl($scope $route-params)
             (setf (@ $scope pages) (array (create :foo "damn") (create :foo "hola")))
             (return nil))))

(define-easy-handler (pages-index :uri "/pages/index.html") ()
  (setf (content-type*) "text/html")
  (with-html-output-to-string 
    (*standard-output* nil)
    (:p "Index")
    (:li :ng-repeat "page in pages"
     (:ul (:p "{{page.foo}}")))))
