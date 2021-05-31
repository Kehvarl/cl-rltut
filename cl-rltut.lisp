;;;; cl-rltut.lisp

(in-package #:cl-rltut)
(defparameter *screen-width* 80)
(defparameter *screen-height* 50)

(defun draw ()
  (blt:clear)
  (blt:refresh))

(defun config ()
  (blt:set "window.resizeable = true")
  (blt:set "window.size = ~Ax~A" *screen-width* *screen-height*)
  (blt:set "window.title = Roguelike"))

(defun main()
  (blt:with-terminal
    (config)
    (loop :do
      (draw)
      (blt:key-case (blt:read)
		    (:escape (return))
		    (:close (return))))))
