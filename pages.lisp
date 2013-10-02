(in-package :site-pages)

(defclass page ()
  ((title :initarg :title
          :initform (error "Title requried")
          :accessor page-title)
   (text :initarg :text
         :accessor page-text)))

(defmacro with-page ((id stream) &body body)
  `(let ((path (merge-pathnames #p"~/pages/" ,id)))
     (when (probe-file path)
       (with-open-file (stream path) ,@body))))

(defun get-page (id)
  (with-page (id stream)
        (let ((text (make-string (file-length stream))))
        (read-sequence text stream)
        (make-instance 'page 
                       :text text
                       :title id))))

(define-resource (pages-index "/pages/index") 
  (let (res (list))
    (maphash (lambda (k v) 
               (push {:id k :title (page-title v)} res))
               *pages*)
             res))

(define-resource (pages-page "/pages/page" id)
  (get-page id))

(define-script (pages-script "/pages/script.js")
  (chain angular
         (module "pages" ["ngResource"])
         (factory "Page" (lambda ($resource) ($resource "/pages/page"))))
  (defun pages-ctrl($scope $route-params $http)
    (chain $http 
           (get "/pages/index") 
           (success (lambda (data) (setf (@ $scope pages) data)))))
  (defun page-ctrl ($scope *page $route-params)
    (setf (@ $scope page) (chain *page (get (create :id (@ $route-params id )))))))
           

(define-html (pages-index-html "/pages/index.html")
    (:p "Index")
    (:li :ng-repeat "page in pages"
     (:ul (:p "{{page.title}}"))))

(define-html (pages-view-html "/pages/view.html")
             (:div :to-markdown "" :text "page.text"))

