;;;; cl-rltut.lisp

(in-package #:cl-rltut)
(defparameter *screen-width* 80)
(defparameter *screen-height* 50)
(defparameter *map-width* 80)
(defparameter *map-height* 45)

(defparameter *map* nil)

(defparameter *color-map* (list :dark-wall (blt:rgba 0 0 100)
				:dark-ground (blt:rgba 50 50 150)))

(defclass entity ()
  ((x :initarg :x :accessor entity/x)
   (y :initarg :y :accessor entity/y)
   (char :initarg :char :accessor entity/char)
   (color :initarg :color :accessor entity/color)))

(defmethod move ((e entity) dx dy)
  (incf (entity/x e) dx)
  (incf (entity/y e) dy))

(defmethod draw ((e entity))
  (with-slots (x y char color) e
    (setf (blt:color) color
	  (blt:cell-char x y) char)))

(defun handle-keys ()
  (let ((action nil))
    (blt:key-case (blt:read)
		  (:up (setf action (list :move (cons 0 -1))))
		  (:down (setf action (list :move (cons 0 1))))
		  (:left (setf action (list :move (cons -1 0))))
		  (:right (setf action (list :move (cons 1 0))))
		  (:close (setf action (list :quit t)))
		  (:escape (setf action (list :quit t))))
    action)) 

(defun render-all (entities map)
  (blt:clear)
  (dotimes (y (game-map/h map))
    (dotimes (x (game-map/w map))
      (let* ((tile (aref (game-map/tiles map) x y))
	     (wall (tile/blocked tile)))
	(if wall
	    (setf (blt:background-color) (getf *color-map* :dark-wall))
	    (setf (blt:background-color) (getf *color-map* :dark-ground))))
      (setf (blt:cell-char x y) #\Space)))

  (mapc #'draw entities)

  (setf (blt:background-color) (blt:black))
  (blt:refresh))

(defun config ()
  (blt:set "window.resizeable = true")
  (blt:set "window.size = ~Ax~A" *screen-width* *screen-height*)
  (blt:set "window.title = Roguelike"))

(defun game-tick (player entities map)
  (render-all entities map)
  (let* ((action (handle-keys))
	 (move (getf action :move))
	 (exit (getf action :quit)))
    (when move
      (unless (blocked-p map
			 (+ (entity/x player) (car move))
			 (+ (entity/y player) (cdr move)))
	(move player (car move) (cdr move))))
    exit))


(defun main ()
  (blt:with-terminal
    (config)
    (let* ((player (make-instance 'entity
				 :x (/ *screen-width* 2)
				 :y (/ *screen-height* 2)
				 :char #\@
				 :color (blt:white)))
	  (npc (make-instance 'entity
			      :x (- (/ *screen-width* 2) 5)
			      :y (/ *screen-height* 2)
			      :char #\@
			      :color (blt:yellow)))
	  (entities (list player npc))
	  (map (make-instance 'game-map :w *map-width* :h *map-height*)))
      (make-map map)

      (do ((exit nil (game-tick player entities map)))
	  (exit)))))
