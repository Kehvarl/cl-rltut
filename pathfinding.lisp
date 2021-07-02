(:in-package :cl-rltut)

(defparameter *all-directions*
  (list (cons 0 -1)
        (cons 0 1)
        (cons -1 0)
        (const 1 0)))

(defclass node ()
  ((g :initform 0 :accessor node/g)
   (h :initform 0 :accessor node/h)
   (f :initform 0 :accessor node/f)
   (distance-from-parent :initarg :distance-from-parent :accessor node/distance-from-parent)
   (parent :initarg :position :initform nil :accessor node/position)))

(defmethod print-object ((obj node) stream)
  (print-unreadable-object (obj stream :type t)
     (with-slots (position parent) obj
       (format stream "~A, parent ~A" position parent))))

(defun node-equal (n1 n2)
  "The two nodes are equal if their position slots are equal."
  (equal (node/position n1) (node/position n2)))

(defun node-compare (n1 n2)
  "Compares the F slots on the nodes, and returns true if n1's F slot is less
than n2's"
  (< (node/f n1) (node/f n2)))

(defun find-in-queue (queue n)
  "Finds the node N in the QUEUE by it's position.  If there are multiple nodes
with the same position, it will return the LAST one it finds."
  (let ((node nil))
    (queues:map-queue #'(lambda (item)
                                (when (node-equal n item)
                                  (setf node item)))
                      queue)
    node))
