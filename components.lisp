(in-package #:cl-rltut)

(defclass component ()
  ((owner :initarg :owner :accessor component/owner)))

(defclass fighter (component)
  ((max-hp :initarg :max-hp :accessor fighter/max-hp :initform nil)
   (hp :initarg :hp :accessor fighter/hp)
   (defense :initarg :defense :accessor fighter/defense)
   (attack :initarg :attack :accessor fighter/attack)))


(defclass basic-monster (component) ())

(defgeneric take-turn (component))

(defmethod take-turn ((component basic-monster))
  (format t "The ~A wonders when it will get to move.~%" (component/owner component)))
