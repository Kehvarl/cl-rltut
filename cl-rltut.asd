;;;; cl-rltut.asd

(asdf:defsystem #:cl-rltut
  :description "Common Lisp Roguelike Tutorial featuring BearLibTerminal"
  :author "Kehvarl"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-blt)
  :components ((:file "package")
               (:file "entity")
	             (:file "tile")
	             (:file "rect")
	             (:file "math")
	             (:file "fov")
	             (:file "game-map")
	             (:file "cl-rltut")
	             ))
