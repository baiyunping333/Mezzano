;;;; Mandelbrot viewer written by Mike "scgtrp" Smith, IPhD.

(defpackage :mandelbrot
  (:use :cl)
  (:export #:spawn))

(in-package :mandelbrot)

(defun hue-to-rgb (h)
  (let* ((h* (/ (rem h 360.0) 60.0))
         (x (- 1 (abs (- (mod h* 2) 1)))))
    (cond
      ((< h* 1) (values 1 x 0))
      ((< h* 2) (values x 1 0))
      ((< h* 3) (values 0 1 x))
      ((< h* 4) (values 0 x 1))
      ((< h* 5) (values x 0 1))
      ((< h* 6) (values 1 0 x)))))

(defun m (cr ci iterations)
  (let ((zr 0) (zi 0))
    (dotimes (i iterations (values 0 0 0))
      (psetf zr (+ cr (- (* zr zr) (* zi zi)))
             zi (+ ci (* zi zr) (* zr zi)))
      (when (> (+ (* zr zr) (* zi zi)) 4)
        (return (hue-to-rgb (+ 180 (* (/ i iterations) 360))))))))

(defun render-mandelbrot (x y width height)
  "Render one pixel."
  (let ((scale (/ 4 width))
        (r 0) (g 0) (b 0))
    (let ((cr (- (* scale (- x (/ width 2))) 0.5))
          (ci (* scale (- y (/ height 2)))))
      (multiple-value-bind (r* g* b*)
          (m cr ci 25)
        (incf r r*)
        (incf g g*)
        (incf b b*)))
    (let ((cr (- (* scale (+ (- x (/ width 2)) 0.5)) 0.5))
          (ci (* scale (- y (/ height 2)))))
      (multiple-value-bind (r* g* b*)
          (m cr ci 25)
        (incf r r*)
        (incf g g*)
        (incf b b*)))
    (let ((cr (- (* scale (- x (/ width 2))) 0.5))
          (ci (* scale (+ (- y (/ height 2)) 0.5))))
      (multiple-value-bind (r* g* b*)
          (m cr ci 25)
        (incf r r*)
        (incf g g*)
        (incf b b*)))
    (let ((cr (- (* scale (+ (- x (/ width 2)) 0.5)) 0.5))
          (ci (* scale (+ (- y (/ height 2)) 0.5))))
      (multiple-value-bind (r* g* b*)
          (m cr ci 25)
        (incf r r*)
        (incf g g*)
        (incf b b*)))
    (logior #xFF000000
            (ash (round (* (/ r 4) 255)) 16)
            (ash (round (* (/ g 4) 255)) 8)
            (round (* (/ b 4) 255)))))

(defgeneric dispatch-event (frame event)
  (:method (f e)))

(defmethod dispatch-event (frame (event mezzanine.gui.compositor:window-activation-event))
  (setf (mezzanine.gui.widgets:activep frame) (mezzanine.gui.compositor:state event))
  (mezzanine.gui.widgets:draw-frame frame))

(defmethod dispatch-event (frame (event mezzanine.gui.compositor:mouse-event))
  (handler-case
      (mezzanine.gui.widgets:frame-mouse-event frame event)
    (mezzanine.gui.widgets:close-button-clicked ()
      (throw 'quit nil))))

(defmethod dispatch-event (frame (event mezzanine.gui.compositor:window-close-event))
  (throw 'quit nil))

(defun mandelbrot-main ()
  (catch 'quit
    (let ((fifo (mezzanine.supervisor:make-fifo 50)))
      (mezzanine.gui.compositor:with-window (window fifo 500 500)
        (let* ((framebuffer (mezzanine.gui.compositor:window-buffer window))
               (frame (make-instance 'mezzanine.gui.widgets:frame
                                     :framebuffer framebuffer
                                     :title "Mandelbrot"
                                     :close-button-p t
                                     :damage-function (mezzanine.gui.widgets:default-damage-function window))))
          (mezzanine.gui.widgets:draw-frame frame)
          (mezzanine.gui.compositor:damage-window window
                                                  0 0
                                                  (mezzanine.gui.compositor:width window)
                                                  (mezzanine.gui.compositor:height window))
          (multiple-value-bind (left right top bottom)
              (mezzanine.gui.widgets:frame-size frame)
            (let ((width (- (mezzanine.gui.compositor:width window) left right))
                  (height (- (mezzanine.gui.compositor:width window) top bottom))
                  (pixel-count 0))
              ;; Render a line at a time, should do this in a seperate thread really...
              ;; More than one thread, even.
              (dotimes (y height)
                (dotimes (x width)
                  (setf (aref framebuffer (+ top y) (+ left x)) (render-mandelbrot x y width height)))
                (mezzanine.gui.compositor:damage-window window left (+ top y) width 1)
                (loop
                   (let ((evt (mezzanine.supervisor:fifo-pop fifo nil)))
                     (when (not evt) (return))
                     (dispatch-event frame evt)))))
            (loop
               (dispatch-event frame (mezzanine.supervisor:fifo-pop fifo)))))))))

(defun spawn ()
  (mezzanine.supervisor:make-thread 'mandelbrot-main
                                    :name "Mandelbrot"
                                    :initial-bindings `((*terminal-io* ,(make-instance 'mezzanine.gui.popup-io-stream:popup-io-stream
                                                                                       :title "Mandelbrot console"))
                                                        (*standard-input* ,(make-synonym-stream '*terminal-io*))
                                                        (*standard-output* ,(make-synonym-stream '*terminal-io*))
                                                        (*error-output* ,(make-synonym-stream '*terminal-io*))
                                                        (*trace-output* ,(make-synonym-stream '*terminal-io*))
                                                        (*debug-io* ,(make-synonym-stream '*terminal-io*))
                                                        (*query-io* ,(make-synonym-stream '*terminal-io*)))))
