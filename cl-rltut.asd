;;;; cl-rltut.asd

(asdf:defsystem #:cl-rltut
  :description "Describe cl-rltut here"
  :author "KEHVARL"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-blt)
  :components ((:file "package")
               (:file "cl-rltut")))
