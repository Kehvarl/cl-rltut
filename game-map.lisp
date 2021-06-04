(in-package #:cl-rltut)

(defclass tile ()
  ((blocked :initarg :blocked
	    :accessor tile/blocked
	    :initform nil)
   (block-sight :initarg :block-sight
		:accessor tile/block-sight
		:initform nil)))

(defmethoc initialize-instance :after ((tile tile) &rest initargs)
  (declare (ignore initargs))
  (with-slots (blocked block-sight) tile
    (if (null block-sight)
	(setf block-sight blocked))))
