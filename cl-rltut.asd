;;;; cl-rltut.asd

(asdf:defsystem #:cl-rltut
  :description "Common Lisp Roguelike Tutorial featuring BearLibTerminal"
  :author "Kehvarl"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-blt #:queues.priority-queue)
  :components ((:file "package")
	             (:file "tile")
	             (:file "rect")
	             (:file "game-map")
               (:file "entity")
               (:file "math")
	             (:file "fov")
               (:file "components")
               (:file "pathfinding")
               (:file "ai")
	             (:file "cl-rltut")
	             ))
