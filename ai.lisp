(in-package #:cl-rltut)

(defclass basic-monster (component) ())

(defmethod take-turn ((component basic-monster) target map entities)
  (let* ((monster (component/owner component))
         (in-sight (tile/visible (aref (game-map/tiles map) (entity/x monster) (entity/y monster)))))
    (when in-sight
      (cond ((>= (distance-to monster target) 2)
             (move-towards monster (entity/x target) (entity/y target) map entities))
            ((> (fighter/hp (entity/fighter target)) 0)
             (format t "The ~A insults you! Your ego is damaged!~%" (entity/name monster)))))))

(defgeneric move-towards (e target-x targey-y map entities))

(defmethod move-towards ((e entity) target-x target-y map entities)
  (with-slots (x y) e
    (let* ((dx (- target-x x))
           (dy (- target-y y))
           (distance (sqrt (+ (expt dx 2) (expt dy 2)))))
      (setf dx (round (/ dx distance))
            dy (round (/ dy distance)))
      (unless (or (blocked-p map (+ x dx) (+ y dy))
                  (blocking-entity-at entities (+ x dx) (+ y dy)))
        (move e dx dy)))))

(defmethod distance-to ((e entity) (other entity))
  (let ((dx (- (entity/x other) (entity/x e)))
        (dy (- (entity/y other) (entity/y e))))
    (sqrt (+ (expt dx 2) (expt dy 2)))))
