(in-package #:cl-rltut)

(defclass component ()
  ((owner :initarg :owner :accessor component/owner)))

(defclass fighter (component)
  ((max-hp :initarg :max-hp :accessor fighter/max-hp :initform nil)
   (hp :initarg :hp :accessor fighter/hp)
   (defense :initarg :defense :accessor fighter/defense)
   (attack :initarg :attack :accessor fighter/attack)))

(defgeneric take-turn (component target map entitites))

(defclass illuminating (component)
  ((radius :initarg :radius :accessor illuminating/radius)
   (brightness :initarg :brightness :accessor illuminating/brightness)))


(defgeneric illuminate (component map))

(defmethod illuminate ((component illuminating) map)
  (let ((source (component/owner component)))
    (light map
           (entity/x source)
           (entity/y source)
           (illuminating/radius component)
           (illuminating/brightness component))))
