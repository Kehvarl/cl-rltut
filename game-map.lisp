(in-package #:cl-rltut)

(defclass game-map ()
  ((width :initarg :w :accessor game-map/w)
   (height :initarg :h :accessor game-map/h)
   (tiles :accessor game-map/tiles)))

(defmacro map-tiles-loop ((map tile-val &key (row-val (gensym))
                                          (col-val (gensym))
                                          (x-start 0) (y-start 0)
                                          (x-end nil) (y-end nil))
                          &body body)
  `(loop :for ,col-val
         :from ,x-start
           :below (if (null ,x-end) (game-map/w ,map) ,x-end)
    :do
      (loop :for ,row-val
             :from ,y-start
               :below (if (null ,y-end) (game-map/h ,map) ,y-end)
       :do
          (let ((,tile-val (aref (game-map/tiles ,map) ,col-val ,row-val)))
              (declare (ignorable ,tile-val))
              ,@body))))

(defmethod initialize-instance :after ((map game-map)
                                       &key (initial-blocked-value t))
  (setf (game-map/tiles map) (make-array (list (game-map/w map)
                                               (game-map/h map))))
  (map-tiles-loop (map tile :col-val x :row-val y)
                  (setf (aref (game-map/tiles map) x y)
                        (make-instance 'tile :blocked initial-blocked-value))))

(defmethod blocked-p ((map game-map) x y)
  (tile/blocked (aref (game-map/tiles map) x y)))

(defmethod initialize-tiles ((map game-map))
  (map-tiles-loop (map tile :col-val x :row-val y)
    (setf (aref (game-map/tiles map) x y) (make-instance 'tile :blocked t))))

(defun entity-at (entities x y)
  (dolist (entity entities)
    (if (and (= (entity/x entity) x)
         (= (entity/y entity) y))
     (return entity))))

(defun blocking-entity-at (entities x y)
  (dolist (entity entities)
    (if (and (= (entity/x entity) x)
         (= (entity/y entity) y)
         (entity/blocks entity))
     (return  entity))))

(defmethod create-room ((map game-map) (room rect))
  (map-tiles-loop (map tile
                   :x-start (1+ (rect/x1 room)) :x-end (rect/x2 room)
                   :y-start (1+ (rect/y1 room)) :y-end (rect/y2 room))
    (set-tile-slots tile :blocked nil :block-sight nil)))

(defmethod create-h-tunnel ((map game-map) x1 x2 y)
  (let ((start-x (min x1 x2))
        (end-x (max x1 x2)))
    (map-tiles-loop (map tile
                     :x-start start-x :x-end (1+ end-x)
                     :y-start y :y-end (1+ y))
      (set-tile-slots tile :blocked nil :block-sight nil))))

(defmethod create-v-tunnel ((map game-map) x y1 y2)
  (let ((start-y (min y1 y2))
        (end-y (max y1 y2)))
    (map-tiles-loop (map tile
                     :x-start x :x-end (1+ x)
                     :y-start start-y :y-end (1+ end-y))
      (set-tile-slots tile :blocked nil :block-sight nil))))

(defmethod place-entities ((map game-map)
                           (room rect)
                           entities
                           max-entities-per-room)
  (let ((num-monsters (random max-entities-per-room)))
    (dotimes (monster-index num-monsters)
      (let ((x (random-x room))
            (y (random-y room)))
       (unless (entity-at entities x y)
          (cond ((< (random 100) 80)
                 (let* ((fighter-component (make-instance 'fighter
                                                          :hp 10
                                                          :defense 0
                                                          :attack 3))
                        (ai-component (make-instance 'basic-monster))
                        (orc (make-instance 'entity
                                            :name "Orc"
                                            :x x :y y :color (blt:green)
                                            :char #\o :blocks t
                                            :fighter fighter-component
                                            :ai ai-component)))
                   (nconc entities (list orc))))
                (t
                 (let* ((fighter-component (make-instance 'fighter
                                                          :hp 16
                                                          :defense 1
                                                          :attack 4))
                        (ai-component (make-instance 'basic-monster))
                        (troll (make-instance 'entity
                                              :name "Troll"
                                              :x x :y y :color (blt:yellow)
                                              :char #\T :blocks t
                                              :fighter fighter-component
                                              :ai ai-component)))
                   (nconc entities (list troll))))))))))

(defmethod make-map ((map game-map) max-rooms room-min-size room-max-size
                     map-width map-height
                     player entities
                     max-entities-per-room)
  (do* ((rooms nil)
        (num-rooms 0)
        (room-index 0 (1+ room-index))
        (w (+ (random (- room-max-size room-min-size)) room-min-size)
           (+ (random (- room-max-size room-min-size)) room-min-size))
        (h (+ (random (- room-max-size room-min-size)) room-min-size)
           (+ (random (- room-max-size room-min-size)) room-min-size))
        (x (random (- map-width w))
           (random (- map-width w)))
        (y (random (- map-height h))
           (random (- map-height h)))
        (new-room (make-instance 'rect :x x :y y :w w :h h)
             (make-instance 'rect :x x :y y :w w :h h))
        (can-place-p t t))
       ((>= room-index max-rooms))
    (dolist (other-room rooms)
      (if (intersect new-room other-room)
       (setf can-place-p nil)))
    (when can-place-p
      (create-room map new-room)
      (multiple-value-bind (new-x new-y) (center new-room)
       (if (zerop num-rooms)
           (setf (entity/x player) new-x
            (entity/y player) new-y)
           (multiple-value-bind (prev-x prev-y) (center (car (last rooms)))
              (cond ((= (random 2) 1)
                     (create-h-tunnel map  prev-x new-x prev-y)
                     (create-v-tunnel map prev-x prev-y new-y))
               (t
                  (create-v-tunnel map prev-x prev-y new-y)
                  (create-h-tunnel map prev-x new-x new-y)))))
       (place-entities map new-room entities max-entities-per-room)
       (if (null rooms)
           (setf rooms (list new-room))
           (push new-room (cdr (last rooms))))
       (incf num-rooms)))))
