(in-package :site-pages)

(defclass page ()
  ((title :initarg :title
          :initform (error "Title requried")
          :accessor page-title)
   (text :initarg :text
         :accessor page-text)))

(defun get-page (id)
  (let ((path (merge-pathnames #p"~/pages/" id)))
    (when (probe-file path)
      (with-open-file (stream path)
        (let ((title (read-line stream))
              (text (make-string (file-length stream))))
          (file-position stream 0)
          (read-sequence text stream)
          (make-instance 'page 
                         :text text
                         :title title))))))

(defparameter *index* (make-hash-table :test 'equal))

(defun refresh-index ()
  (let ((index #p"~/pages/.index"))
    (when (probe-file index) (delete-file index))
    (mapcar (lambda (path) 
              (let ((f (file-namestring path)))
                (setf (gethash f *index*) (get-page f))))
            (directory #p"~/pages/*"))
    (with-open-file (stream index
                            :direction :output
                            :if-does-not-exist :create)
      (maphash (lambda (k v) (format stream "~a~%" k)) *index*))))

(define-resource (pages-index "/pages/index") 
  (let (res (list))
    (maphash (lambda (k v) 
               (push {:id k :title (page-title v)} res))
               *index*)
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
     (:ul (:a :href "#/page/{{page.id}}" "{{page.title}}"))))

(define-html (pages-view-html "/pages/view.html")
             (:div :to-markdown "" :text "page.text"))

