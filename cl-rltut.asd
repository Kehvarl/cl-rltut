;;;; cl-rltut.asd

(asdf:defsystem #:cl-rltut
  :description "Common Lisp Roguelike Tutorial featuring BearLibTerminal"
  :author "Kehvarl"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-blt)
  :components ((:file "package")
               (:file "cl-rltut")
	       (:file "tile")
	       (:file "rect")
	       (:file "game-map")
	       (:file "fov")))
