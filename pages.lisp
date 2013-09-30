(in-package :site-pages)

(defclass page ()
  ((title :initarg :title
          :initform (error "Title requried")
          :accessor page-title)
   (text :initarg :text
         :accessor page-text)))

(defparameter *pages* (make-hash-table :test 'equal))
(setf (gethash "firstPage" *pages*) 
      (make-instance 'page
                     :title "First page" :text "This is the page' text"))
(setf (gethash "secondPage" *pages*) 
      (make-instance 'page
                     :title "Second page" :text "Omnomnomnom"))

(define-resource (pages-index "/pages/index") 
  (let (res (list))
    (maphash (lambda (k v) 
               (push {:id k :title (page-title v)} res))
               *pages*)
             res))

(define-resource (pages-page "/pages/page" id)
  (gethash id *pages*))

(define-script (pages-script "/pages/script.js")
  (defun pages-ctrl($scope $route-params $http)
    (chain $http 
           (get "/pages/index") 
           (success (lambda (data) (setf (@ $scope pages) data)))))
  (defun page-ctrl ($scope $http)
    (chain $http
           (get (+ "/page?id=" (@ $scope id)))
           (success (lambda (data) (setf (@ $scope page) data))))))
           

(define-html (pages-index-html "/pages/index.html")
    (:p "Index")
    (:li :ng-repeat "page in pages"
     (:ul (:p "{{page.title}}"))))

(define-html (pages-view-html "/pages/view.html")
             (:div "{{page.text}}"))

