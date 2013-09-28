(in-package :site-pages)

(define-script (pages-script "/pages/script.js")
  (defun pages-ctrl($scope $route-params)
    (setf (@ $scope pages) (array (create :foo "damn") (create :foo "hola")))
    (return nil)))

(define-html (pages-index "/pages/index.html")
    (:p "Index")
    (:li :ng-repeat "page in pages"
     (:ul (:p "{{page.foo}}"))))


