(in-package #:cl-rltut)

(defclass rect ()
  ((x1 :initarg :x1 :accessor rect/x1)
   (x2 :initarg :x2 :accessor rect/x2)
   (y1 :initarg :y1 :accessor rect/y1)
   (y2 :initarg :y2 :accessor rect/y2)))

(defmethod initialize-instance :after ((rect rect) &key x y w h)
  (with-slots (x1 x2 y1 y2) rect
    (setf x1 x
	  y1 y
	  x2 (+ x w)
	  y2 (+ y h))))

(defmethod center ((rect rect))
  (with-slots (x1 x2 y1 y2) rect
    (let ((center-x (round (/ (+ x1 x2) 2)))
	  (center-y (round (/ (+ y1 y2) 2))))
      (values center-x center-y))))

(defmethod intersect ((rect rect) (other rect))
  "Returns T if this RECT intersects with OTHER"
  (and (<= (rect/x1 rect) (rect/x2 other))
       (<= (rect/x2 rect) (rect/x1 other))
       (<= (rect/y1 rect) (rect/y2 other))
       (<= (rect/y2 rect) (rect/y1 other))))

(defmethod random-x ((rect rect))
  (with-slots (x1 x2) rect
  (+ (random (round (/ (- x2 x1 1) 2))) (1+ x1))))

(defmethod random-y ((rect rect))
  (with-slots (y1 y2) rect
  (+ (random (round (/ (- y2 y1 1) 2))) (1+ y1))))
