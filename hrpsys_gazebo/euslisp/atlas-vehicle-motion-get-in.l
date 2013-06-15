
;; \file    atlas-vehicle-motion-get-in.l
;; \author  Murooka Masaki
;; \date    2013/06/15
;; \brief   vrc_task_1関連 その他の行動要素関数
;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; vehicle motion [get-in]
(defun get-in-for-task1
  (&key (real nil) (wait nil) (telep nil))

  (warning-message 2 "[vhc-get-in] start (get-in-for-task1)~%")

  (telep-in-get-in-for-task1 :real real :wait wait :telep telep)

  (grasp-ulp-with-rh-in-get-in-for-task1 :real real :wait wait)

  (warning-message 2 "[vhc-get-in] finish (get-in-for-task1)~%")
  )

(defun telep-in-get-in-for-task1
  (&key (real nil) (wait nil) (init nil) (telep t))

  (warning-message 2 "[vhc-get-in] start (telep-in-get-in-for-task1)~%")

  (make-vehicle)

  (when init
    (warning-message 2 "[vhc-get-in] call (my-init)~%")
    (my-init :real real)
    (send *irtviewer* :draw-objects))

  (when (and real telep)
    (warning-message 2 "[vhc-get-in] call (telep-start) and (stand-up-start)~%")
    (my-init :real real)
    (telep-start)
    (stand-up-start))

  (when real
    (warning-message 2 "[vhc-get-in] call (manip)~%")
    (when wait (my-wait))
    (manip)
    (send *irtviewer* :draw-objects))

  (warning-message 2 "[vhc-get-in] grasp rarm and ungrasp larm~%")
  (when wait (my-wait))
  (grasp :arm :rarm :real real)
  (ungrasp :arm :larm :real real)
  (send *irtviewer* :draw-objects)

  (warning-message 2 "[vhc-get-in] angle-vector before teleport~%")
  (when wait (my-wait))
  (send *atlas* :angle-vector #f(0.0 0.0 0.0 23.5 114.5 0.0 -75.0 17.0 0.0 -135.0 129.6 -71.6129 79.9998 60.7501 0.0 61.5619 -1.79235 -35.568 1.79235 -25.994 0.012938 61.5446 1.91967 -35.5619 -1.91967 -25.9828 0.01294 0.0))
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t))

  (warning-message 2 "[vhc-get-in] call :teleport~%")
  (when wait (my-wait))
  (when (and real telep) 
    (send *ri* :teleport-to (send (send *vehicle-side-pos* :copy-worldcoords) :translate #f(0 0 950) :world) nil :keep-effort t))
  (send *atlas* :fix-leg-to-coords *vehicle-side-pos* '(:lleg :rleg))
  (send *irtviewer* :draw-objects)

  (make-vehicle)

  (warning-message 2 "[vhc-get-in] finish (telep-in-get-in-for-task1)~%")
  )

(defun grasp-ulp-with-rh-in-get-in-for-task1
  (&key (real nil) (wait nil))

  (warning-message 2 "[vhc-get-in] start (grasp-ulp-with-rh-in-get-in-for-task1)~%")

  (let* ((pipe-coords
	  (send (send (send *drcv* :handle :name :upper-left-pipe) :copy-worldcoords) :translate #f(0 0 0) :local)))

    (when real
      (warning-message 2 "[vhc-get-in] set high-gain :rarm and zero-gain :head for grasp-ulp-with-rh~%")
      (when wait (my-wait))
      (set-high-gain :rarm)
      (set-zero-gain :head))

    (warning-message 2 "[vhc-get-in] angle-vector1 for grasp-ulp-with-rh~%")
    (when wait (my-wait))
    ;; (if real (real2model))
    (send *atlas* :bdi-stand-pose)
    (fix-leg-vehicle-side)
    (send *atlas* :rarm :inverse-kinematics 
	  (send (send pipe-coords :copy-worldcoords)
		:transform (make-coords :pos #f(516 84 98) :rpy '(0.374725 0.848509 2.09956)))
	  :target-centroid-pos (send (send (send (send *atlas* :foot-midcoords) :copy-worldcoords) :translate #f(-50 0 0)) :pos)
	  :centroid-thre 200
	  :rotation-axis nil :thre 5)
    (fix-leg-vehicle-side)
    (move-centroid)
    (send *irtviewer* :draw-objects)
    (when real (model2real :wait t))

    (warning-message 2 "[vhc-get-in] angle-vector2 for grasp-ulp-with-rh~%")
    (when wait (my-wait))
    (send *atlas* :rarm :inverse-kinematics
	  (send (send pipe-coords :copy-worldcoords)
		:transform (make-coords :pos #f(112 189 104) :rpy '(-1.09049 0.919819 0.813976)))
	  :target-centroid-pos (send (send (send (send *atlas* :foot-midcoords) :copy-worldcoords) :translate #f(-50 0 0)) :pos)
	  :centroid-thre 200
	  :rotation-axis nil :thre 5)
    (fix-leg-vehicle-side)
    (move-centroid)
    (send *irtviewer* :draw-objects)
    (when real (model2real :wait t))

    (warning-message 2 "[vhc-get-in] ungrasp rarm for grasp-ulp-with-rh~%")
    (when wait (my-wait))
    (ungrasp :arm :rarm :real real)
    (send *irtviewer* :draw-objects)
    (when real (unix::usleep (* 2 1000 1000)))

    (warning-message 2 "[vhc-get-in] angle-vector3 for grasp-ulp-with-rh~%")
    (when wait (my-wait))
    (send *atlas* :rarm :inverse-kinematics
	  (send (send pipe-coords :copy-worldcoords)
		:transform (make-coords :pos #f(58 104 30) :rpy '(0 0 0)))
	  :target-centroid-pos (send (send (send (send *atlas* :foot-midcoords) :copy-worldcoords) :translate #f(-50 0 0)) :pos)
	  :centroid-thre 200
	  :translation-axis :z :rotation-axis :z :thre 5)
    (fix-leg-vehicle-side)
    (move-centroid)
    (send *irtviewer* :draw-objects)
    (when real (model2real :wait t))

    (warning-message 2 "[vhc-get-in] angle-vector4 for grasp-ulp-with-rh~%")
    (when wait (my-wait))
    (send *atlas* :rarm :inverse-kinematics
	  pipe-coords
	  :target-centroid-pos (send (send (send (send *atlas* :foot-midcoords) :copy-worldcoords) :translate #f(-50 0 0)) :pos)
	  :centroid-thre 200
	  :rotation-axis :z :thre 5)
    (fix-leg-vehicle-side)
    (move-centroid)
    (send *irtviewer* :draw-objects)
    (when real (model2real :wait t))

    (when real
      (warning-message 2 "[vhc-get-in] set middle-gain :rarm for grasp-ulp-with-rh~%")
      (when wait (my-wait))
      (set-middle-gain :rarm))

    (warning-message 2 "[vhc-get-in] grasp rarm for grasp-ulp-with-rh~%")
    (when wait (my-wait))
    (grasp :arm :rarm :real real)
    (send *irtviewer* :draw-objects)
    (when real (unix::usleep (* 10 1000 1000)))

    (when real
      (warning-message 2 "[vhc-get-in] adapt angle-vector for grasp-ulp-with-rh~%")
      (when wait (my-wait))
      (real2model)
      (send *irtviewer* :draw-objects)
      (model2real :time 1000 :wait t))

    (when real
      (warning-message 2 "[vhc-get-in] set high-gain :rarm for grasp-ulp-with-rh~%")
      (when wait (my-wait))
      (set-high-gain :rarm))

    (when real
      (when wait (my-wait))
      (warning-message 2 "[vhc-get-in] call (set-user) for grasp-ulp-with-rh~%")
      (set-user))

    )

  (warning-message 2 "[vhc-get-in] finish (grasp-ulp-with-rh-in-get-in-for-task1)~%")
  )





(defun get-in-vehicle-side-get-in-right-leg
  (&key (real nil) (wait nil))

  (when real
    (warning-message 2 "[vhc-get-in] set larm kp 0.1 ~%")
    (when wait (my-wait))
    (atlas-set-servo-gain-by-torque-limit 1000.0 :larm))

  (warning-message 2 "[vhc-get-in] lift right leg on ground~%")
  (when wait (my-wait))
  (let* ((tc (list (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(195 0 500) :world)
		   nil
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 300 0) :world))))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	   :link-list ll :move-target mt
	   :collision-avoidance-link-pair nil
	   :stop 1000	   
	   :translation-axis '(t t t t)
	   :rotation-axis '(t t t nil)
	   :thre '(10 10 10 1000)
	   :target-centroid-pos (send (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(-50 0 0)) :pos)
	   :centroid-thre 200)))
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t :time 1000))
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))

  (warning-message 2 "[vhc-get-in] turn right leg in yaw direction~%")
  (when wait (my-wait))
  (send (send *atlas* :rleg :crotch-y) :joint-angle -40)
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t :time 1000))

  (warning-message 2 "[vhc-get-in] move right leg in vehicle~%")
  (when wait (my-wait))
  (let* ((tc (list (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(125 -60 25) :local)
		   nil
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 300 0) :world))))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	   :link-list ll :move-target mt
	   :collision-avoidance-link-pair nil
	   :stop 1000	   
	   :translation-axis '(t t t t)
	   :rotation-axis '(t t t nil)
	   :thre '(10 10 10 1000)
	   :target-centroid-pos (send (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(-30 0 0)) :pos)
	   :centroid-thre 200)))
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t :time 1000))
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))

  (warning-message 2 "[vhc-get-in] take down right leg in vehicle~%")
  (when wait (my-wait))
  (let* ((tc (list (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(0 0 -150) :world)
		   nil
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 300 0) :world))))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	   :link-list ll :move-target mt
	   :collision-avoidance-link-pair nil
	   :stop 1000	   
	   :translation-axis '(t t t t)
	   :rotation-axis '(t t t nil)
	   :thre '(10 10 10 1000)
	   :target-centroid-pos (send (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(-30 0 0)) :pos)
	   :centroid-thre 200)))
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t))
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))

  (warning-message 2 "[vhc-get-in] lift left leg on ground~%")
  (when wait (my-wait))
  (let* ((tc (list nil
		   (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 -125 75) :world)
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 300 0) :world))))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	   :link-list ll :move-target mt
	   :collision-avoidance-link-pair nil
	   :stop 1000	   
	   :translation-axis '(t t t t)
	   :rotation-axis '(t t t nil)
	   :thre '(10 10 10 1000)
	   :target-centroid-pos (send (send (send (send *atlas* :foot-midcoords) :copy-worldcoords) :translate #f(-30 -20 0)) :pos)
	   :centroid-thre 200)))
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t :time 2000))
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))

  (warning-message 2 "[vhc-get-in] take down left leg on ground~%")
  (when wait (my-wait))
  (let* ((tc (list nil
		   (make-coords :pos (send (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 -125 -75) :world) :worldpos))
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 300 0) :world))))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	   :link-list ll :move-target mt
	   :collision-avoidance-link-pair nil
	   :stop 1000	   
	   :translation-axis '(t t t t)
	   :rotation-axis '(t t t nil)
	   :thre '(10 10 10 1000)
	   :target-centroid-pos (send (send (send (send *atlas* :foot-midcoords) :copy-worldcoords) :translate #f(-30 -20 0)) :pos)
	   :centroid-thre 200)))
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t :time 2000))
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))
  )

(defun get-in-vehicle-side-get-in-right-leg-inner
  (&key (real nil) (wait nil))

  (warning-message 2 "[vhc-get-in] lift right leg on vehicle~%")
  (when wait (my-wait))
  (let* ((tc (list (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(0 0 100) :world)
		   nil
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 300 0) :world))))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
  	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
  	   :link-list ll :move-target mt
  	   :collision-avoidance-link-pair nil
	   :stop 1000  	   
	   :translation-axis '(t t t nil)
  	   :rotation-axis '(t t t nil)
	   :thre '(5 5 10 10)
	   :rthre (list (deg2rad 1) (deg2rad 1) (deg2rad 2) (deg2rad 2))
	   :target-centroid-pos (send (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 0 0)) :pos)
  	   :centroid-thre 200)))
  (when real (model2real :wait t))
  (send *irtviewer* :draw-objects)
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))

  (warning-message 2 "[vhc-get-in] move right leg in vehicle~%")
  (when wait (my-wait))
  (let* ((tc (list (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(100 -175 25) :local)
		   nil
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 300 0) :world))))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
  	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
  	   :link-list ll :move-target mt
  	   :collision-avoidance-link-pair nil
	   :stop 1000  	   
	   :translation-axis '(t t t nil)
  	   :rotation-axis '(t t t nil)
	   :thre '(5 5 10 10)
	   :rthre (list (deg2rad 1) (deg2rad 1) (deg2rad 2) (deg2rad 2))
	   :target-centroid-pos (send (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 0 0)) :pos)
  	   :centroid-thre 200)))
  (when real (model2real :wait t))
  (send *irtviewer* :draw-objects)
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))

  (warning-message 2 "[vhc-get-in] take down right leg on vehicle~%")
  (when wait (my-wait))
  (let* ((tc (list (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(0 0 -120) :world)
		   nil
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 300 0) :world))))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
  	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
  	   :link-list ll :move-target mt
  	   :collision-avoidance-link-pair nil
	   :stop 1000  	   
	   :translation-axis '(t t t nil)
  	   :rotation-axis '(t t t nil)
	   :thre '(5 5 10 10)
	   :rthre (list (deg2rad 1) (deg2rad 1) (deg2rad 2) (deg2rad 2))
	   :target-centroid-pos (send (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 0 0)) :pos)
  	   :centroid-thre 200)))
  (when real (model2real :wait t))
  (send *irtviewer* :draw-objects)
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))
  )

(defun get-in-vehicle-side-grasp-front-left-pipe-with-left-hand
  (&key (real nil) (wait nil))

  (let* ((pipe-coords
	  (send (send (send *drcv* :handle :name :front-left-pipe) :copy-worldcoords) :translate #f(0 0 0) :local)))

    ;; (when real
    ;;   (warning-message 2 "[vhc-get-in] adapt angle-vector~%")
    ;;   (when wait (my-wait))
    ;;   (real2model)
    ;;   (model2real)
    ;;   (send *irtviewer* :draw-objects)
    ;;   (model2real :wait t))

    (when real
      (warning-message 2 "[vhc-get-in] set larm kp 100 ~%")
      (when wait (my-wait))
      (atlas-set-servo-gain-by-torque-limit 1.0 :larm))

    (warning-message 2 "[vhc-get-in] angle-vector1 for reaching pipe with left arm~%")
    (when wait (my-wait))
    (let* ((tc (list nil
		     nil
		     nil
		     (send (send pipe-coords :copy-worldcoords) :translate #f(-100 -300 100) :local))))
      (with-move-target-link-list
       (mt ll *atlas* '(:rleg :lleg :rarm :larm))
       (send *atlas* :fullbody-inverse-kinematics
	     (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	     :link-list ll :move-target mt
	     :collision-avoidance-link-pair nil
	     :translation-axis '(t t t :z)
	     :rotation-axis '(t t t :z)
	     :thre '(1 1 5 100)
	     :rthre (list (deg2rad 1) (deg2rad 1) (deg2rad 20) (deg2rad 20))
	     :centroid-thre 300)))
    (send *irtviewer* :draw-objects)
    (when real (model2real :time 5000 :wait t))
    (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
    (setq *last-atlas-av* (send *atlas* :angle-vector))

    (warning-message 2 "[vhc-get-in] angle-vector2 for reaching pipe with left arm~%")
    (when wait (my-wait))
    (let* ((tc (list nil
		     nil
		     nil
		     pipe-coords)))
      (with-move-target-link-list
       (mt ll *atlas* '(:rleg :lleg :rarm :larm))
       (send *atlas* :fullbody-inverse-kinematics
	     (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	     :link-list ll :move-target mt
	     :collision-avoidance-link-pair nil
	     :translation-axis '(t t t t)
	     :rotation-axis '(t t t :z)
	     :thre '(5 5 10 10)
	     :rthre (list (deg2rad 1) (deg2rad 1) (deg2rad 2) (deg2rad 2))
	     :centroid-thre 300)))
    (send *irtviewer* :draw-objects)
    (when real (model2real :wait t))
    (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
    (setq *last-atlas-av* (send *atlas* :angle-vector))

    (warning-message 2 "[vhc-get-in] grasp larm and ungrasp rarm~%")
    (when wait (my-wait))
    (grasp :arm :larm :real real)
    (send *irtviewer* :draw-objects)
    (when real (unix::usleep (* 5 1000 1000)))
    (ungrasp :arm :rarm :real real)
    (send *irtviewer* :draw-objects)
    (when real (unix::usleep (* 5 1000 1000)))

    (warning-message 2 "[vhc-get-in] angle-vector1 for release pipe with right arm~%")
    (when wait (my-wait))
    (let* ((tc (list nil
		     nil
		     (send (send (send *drcv* :handle :name :upper-left-pipe) :copy-worldcoords) :transform (make-coords :pos #f(100 200 0) :rpy '(0 0 0)))
		     nil)))
      (with-move-target-link-list
       (mt ll *atlas* '(:rleg :lleg :rarm :larm))
       (send *atlas* :fullbody-inverse-kinematics
	     (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	     :link-list ll :move-target mt
	     :collision-avoidance-link-pair nil
	     :translation-axis '(t t :z t)
	     :rotation-axis '(t t :z t)
	     :thre '(5 5 10 10)
	     :centroid-thre 300)))
    (send *irtviewer* :draw-objects)
    (when real (model2real :wait t))
    (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
    (setq *last-atlas-av* (send *atlas* :angle-vector))

    (when real
      (warning-message 2 "[vhc-get-in] set rarm kp 0.1 ~%")
      (when wait (my-wait))
      (atlas-set-servo-gain-by-torque-limit 1000.0 :rarm))
    ))

(defun get-in-vehicle-side-get-in-left-leg
  (&key (real nil) (wait nil))

  (warning-message 2 "[vhc-get-in] lift left leg on ground~%")
  (when wait (my-wait))
  (let* ((tc (list nil
		   (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 50 200) :world)
		   nil
		   nil)))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	   :link-list ll :move-target mt
	   :collision-avoidance-link-pair nil
	   :stop 1000	   
	   :translation-axis '(t t nil t)
	   :rotation-axis '(t :z nil t)
	   :thre '(5 5 10 10)
	   :rthre (list (deg2rad 2) (deg2rad 2) (deg2rad 2) (deg2rad 2))
	   :target-centroid-pos (send (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(0 50 1000)) :pos)
	   :centroid-thre 200)))
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t :time 1000))
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))

  (warning-message 2 "[vhc-get-in] lift left leg in air~%")
  (when wait (my-wait))
  (let* ((tc (list nil
		   (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 25 300) :world)
		   nil
		   nil)))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	   :link-list ll :move-target mt
	   :collision-avoidance-link-pair nil
	   :stop 1000	   
	   :translation-axis '(t t nil t)
	   :rotation-axis '(t :z nil t)
	   :thre '(5 5 10 10)
	   :target-centroid-pos (send (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(0 50 1000)) :pos)
	   :centroid-thre 200)))
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t :time 1000))
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))

  (warning-message 2 "[vhc-get-in] move left leg in air~%")
  (when wait (my-wait))
  (let* ((tc (list nil
		   (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(150 -300 50) :world)
		   nil
		   nil)))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	   :link-list ll :move-target mt
	   :collision-avoidance-link-pair nil
	   :stop 1000	   
	   :translation-axis '(t t nil t)
	   :rotation-axis '(t :z nil t)
	   :thre '(5 5 10 10)
	   :target-centroid-pos (send (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(0 50 1000)) :pos)
	   :centroid-thre 200)))
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t :time 1000))
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))

  (warning-message 2 "[vhc-get-in] take down left leg on vehicle~%")
  (when wait (my-wait))
  (let* ((tc (list nil
		   (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 0 -125) :world)
		   nil
		   nil)))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	   :link-list ll :move-target mt
	   :collision-avoidance-link-pair nil
	   :stop 1000	   
	   :translation-axis '(t t nil t)
	   :rotation-axis '(t :z nil t)
	   :thre '(5 5 10 10)
	   :target-centroid-pos (send (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(0 50 1000)) :pos)
	   :centroid-thre 200)))
  (send *irtviewer* :draw-objects)
  (when real (model2real :wait t :time 1000))
  (setq *last-atlas-worldcoords* (send (send *atlas* :worldcoords) :copy-worldcoords))
  (setq *last-atlas-av* (send *atlas* :angle-vector))
  )




(defun get-in-vehicle-side
  (&key (real nil) (wait nil) (only-teleport nil) (teleport t))

  (get-in-vehicle-side-teleport :real real :wait wait :teleport teleport)

  (when only-teleport (return-from get-in-vehicle-side nil))

  (get-in-vehicle-side-grasp-upper-left-pipe-with-right-hand :real real :wait wait)

  (get-in-vehicle-side-get-in-right-leg :real real :wait wait)

  (get-in-vehicle-side-get-in-right-leg-inner :real real :wait wait)

  (get-in-vehicle-side-grasp-front-left-pipe-with-left-hand :real real :wait wait)

  (get-in-vehicle-side-get-in-left-leg :real real :wait wait)
  )








;; not used

(defun get-in-vehicle-side-grasp-upper-left-pipe-with-left-hand
  (&key (real nil) (wait nil))

  (let* ((pipe-coords
	  (send (send (send *drcv* :handle :name :upper-left-pipe) :copy-worldcoords) :translate #f(10 -60 200) :local)))

    ;; (when real
    ;;   (warning-message 2 "[vhc-get-in] adapt angle-vector~%")
    ;;   (when wait (my-wait))
    ;;   (real2model)
    ;;   (model2real)
    ;;   (send *irtviewer* :draw-objects)
    ;;   (model2real :wait t))

    (when real
      (warning-message 2 "[vhc-get-in] set larm kp 100 ~%")
      (when wait (my-wait))
      (atlas-set-servo-gain-by-torque-limit 1.0 :larm))

    (warning-message 2 "[vhc-get-in] angle-vector1 for reaching pipe with left arm~%")
    (when wait (my-wait))
    (let* ((tc (list nil
		     nil
		     nil
		     (send (send pipe-coords :copy-worldcoords) :translate #f(100 -300 100) :local))))
      (with-move-target-link-list
       (mt ll *atlas* '(:rleg :lleg :rarm :larm))
       (send *atlas* :fullbody-inverse-kinematics
	     (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	     :link-list ll :move-target mt
	     :collision-avoidance-link-pair nil
	     :translation-axis '(t t t t)
	     :rotation-axis '(t t t :z)
	     :thre '(5 5 10 10)
	     :centroid-thre 300)))
    (send *irtviewer* :draw-objects)
    (when real (model2real :wait t))

    (warning-message 2 "[vhc-get-in] angle-vector2 for reaching pipe with left arm~%")
    (when wait (my-wait))
    (let* ((tc (list nil
		     nil
		     nil
		     pipe-coords)))
      (with-move-target-link-list
       (mt ll *atlas* '(:rleg :lleg :rarm :larm))
       (send *atlas* :fullbody-inverse-kinematics
	     (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	     :link-list ll :move-target mt
	     :collision-avoidance-link-pair nil
	     :translation-axis '(t t t t)
	     :rotation-axis '(t t t :z)
	     :thre '(5 5 10 10)
	     :rthre (list (deg2rad 1) (deg2rad 1) (deg2rad 2) (deg2rad 2))
	     :centroid-thre 300)))
    (send *irtviewer* :draw-objects)
    (when real (model2real :wait t))

    (warning-message 2 "[vhc-get-in] grasp larm and ungrasp rarm~%")
    (when wait (my-wait))
    (grasp :arm :larm :real real)
    (send *irtviewer* :draw-objects)
    (when real (unix::usleep (* 5 1000 1000)))
    (ungrasp :arm :rarm :real real)
    (send *irtviewer* :draw-objects)
    (when real (unix::usleep (* 5 1000 1000)))

    (warning-message 2 "[vhc-get-in] angle-vector1 for release pipe with right arm~%")
    (when wait (my-wait))
    (let* ((tc (list nil
		     nil
		     (send (send pipe-coords :copy-worldcoords) :transform (make-coords :pos #f(100 200 0) :rpy '(0 0 0)))
		     nil)))
      (with-move-target-link-list
       (mt ll *atlas* '(:rleg :lleg :rarm :larm))
       (send *atlas* :fullbody-inverse-kinematics
	     (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
	     :link-list ll :move-target mt
	     :collision-avoidance-link-pair nil
	     :translation-axis '(t t t t)
	     :rotation-axis '(t t :z t)
	     :thre '(5 5 10 10)
	     :centroid-thre 300)))
    (send *irtviewer* :draw-objects)
    (when real (model2real :wait t))
    ))

(defun get-in-vehicle-side-get-in-right-leg-inner2
  (&key (real nil) (wait nil))

  (warning-message 2 "[vhc-get-in] lift right leg on vehicle~%")
  (when wait (my-wait))
  (let* ((tc (list (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(0 0 100) :world)
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 -200 0) :world)
		   nil)))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
  	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
  	   :link-list ll :move-target mt
  	   :collision-avoidance-link-pair nil
	   :stop 1000  	   
	   :translation-axis '(t t nil t)
  	   :rotation-axis '(t t nil t)
	   :thre '(5 5 10 10)
	   ;; :target-centroid-pos (send (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 0 0)) :pos)
  	   :centroid-thre 200)))
  (when real (model2real :wait t))
  (send *irtviewer* :draw-objects)

  (warning-message 2 "[vhc-get-in] move right leg in vehicle~%")
  (when wait (my-wait))
  (let* ((tc (list (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(75 -100 0) :local)
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 -200 0) :world)
		   nil)))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
  	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
  	   :link-list ll :move-target mt
  	   :collision-avoidance-link-pair nil
	   :stop 1000  	   
	   :translation-axis '(t t nil t)
  	   :rotation-axis '(t t nil t)
	   :thre '(5 5 10 10)
	   ;; :target-centroid-pos (send (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 0 0)) :pos)
  	   :centroid-thre 200)))
  (when real (model2real :wait t))
  (send *irtviewer* :draw-objects)

  (warning-message 2 "[vhc-get-in] take down right leg on vehicle~%")
  (when wait (my-wait))
  (let* ((tc (list (send (send *atlas* :rleg :end-coords :copy-worldcoords) :translate #f(0 0 -100) :world)
		   nil
		   (send (send (send *atlas* :worldcoords) :copy-worldcoords) :translate #f(0 -200 0) :world)
		   nil)))
    (with-move-target-link-list
     (mt ll *atlas* '(:rleg :lleg :rarm :larm))
     (send *atlas* :fullbody-inverse-kinematics
  	   (mapcar #'(lambda (c m) (if c c (send m :copy-worldcoords))) tc mt)
  	   :link-list ll :move-target mt
  	   :collision-avoidance-link-pair nil
	   :stop 1000  	   
	   :translation-axis '(t t nil t)
  	   :rotation-axis '(t t nil t)
	   :thre '(5 5 10 10)
	   ;; :target-centroid-pos (send (send (send *atlas* :lleg :end-coords :copy-worldcoords) :translate #f(0 0 0)) :pos)
  	   :centroid-thre 200)))
  (when real (model2real :wait t))
  (send *irtviewer* :draw-objects)
  )
