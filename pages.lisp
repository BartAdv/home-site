(in-package :site-pages)

(defstruct page
  (title nil :type string)
  (text nil :type string))

(defparameter *pages* (make-hash-table))
(setf (gethash :first-page *pages*) 
      (make-page :title "First page" :text "This is the page' text"))
(setf (gethash :second-page *pages*) 
      (make-page :title "Second page" :text "Omnomnomnom"))

(define-resource (pages-index "/pages/index") 
  (let (res (list))
    (maphash (lambda (k v) 
               (push {:id k :title (page-title v)} res))
               *pages*)
             res))

(define-script (pages-script "/pages/script.js")
  (defun pages-ctrl($scope $route-params $http)
    (chain $http 
           (get "/pages/index") 
           (success (lambda (data) (setf (@ $scope pages) data))))
    (return nil)))

(define-html (pages-index-html "/pages/index.html")
    (:p "Index")
    (:li :ng-repeat "page in pages"
     (:ul (:p "{{page.title}}"))))


