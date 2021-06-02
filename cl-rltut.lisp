;;;; cl-rltut.lisp

(in-package #:cl-rltut)
(defparameter *screen-width* 80)
(defparameter *screen-height* 50)

(defun draw (player-x player-y)
  (blt:clear)
  (setf (blt:color) (blt:white)
	(blt:cell-char player-x player-y) #\@)
  (blt:refresh))

(defun config ()
  (blt:set "window.resizeable = true")
  (blt:set "window.size = ~Ax~A" *screen-width* *screen-height*)
  (blt:set "window.title = Roguelike"))

(defun main()
  (blt:with-terminal
    (config)
    (loop :do
      (draw 10 15)
      (blt:key-case (blt:read)
		    (:escape (return))
		    (:close (return))))))
