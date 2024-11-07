;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                                        ;;;
;;;     __  .______     ______   .__   __.    .______    __    _______.                    ;;;
;;;    |  | |   _  \   /  __  \  |  \ |  |    |   _  \  |  |  /  _____|        _____       ;;;
;;;    |  | |  |_)  | |  |  |  | |   \|  |    |  |_)  | |  | |  |  __      ^..^     \9     ;;;
;;;    |  | |      /  |  |  |  | |  . `  |    |   ___/  |  | |  | |_ |     (oo)_____/      ;;;
;;;    |  | |  |\  \  |  `--'  | |  |\   |    |  |      |  | |  |__| |        WW  WW       ;;;
;;;    |__| | _| `._|  \______/  |__| \__|    | _|      |__|  \______|                     ;;;
;;;                                                                                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;; Author: Ivan Jordaan
;; Date: 2024-10-18
;; email: ivan@axoinvent.com
;; Project: Component structs
;;

;;;
;;;; Consts
;;;

(define DEFAULT_EXECUTABLE_RESULT #t)

;;;
;;;; Structs
;;;

(define-structure component ID data procedure executable?)

;;;
;;;; Data
;;;

(define (unpack-data state comp)
  (apply append
         `((state: ,state)
           ,@(map
              (lambda (arg)
                (let* ((key (car arg))
                       (skey (symbol->string key))
                       (is-ref? (char=? (string-ref skey 0) #\>)))
                  (if is-ref?
                      (let ((ref (substring skey 1 (string-length skey))))
                        (list (string->keyword ref) (cdr (state-ref state (string->symbol ref) executable?: (cdr arg)))))
                      (list (string->keyword skey) (cdr arg)))))
              (component-data comp)))))

;;;
;;;; Ref comp
;;;

(define (ref s #!key (executable? #f))
  (cons (string->symbol (string-append ">" (symbol->string s))) executable?))

;;;
;;;; Executing procedures
;;;

(define (%execute state comp)
  (if (component-executable? comp)
      (apply (component-procedure comp) (unpack-data state comp))))

;;;
;;;; Define executable component
;;;

(define (make-executable-comp ID procedure . data)
  (make-component ID data procedure #t))

;;;
;;;; Define data holder
;;;

(define (make-data-comp ID . data)
  (make-component ID data (lambda () DEFAULT_EXECUTABLE_RESULT) #f))

;;;
;;;; Make comp executable
;;;

(define (make-comp-executable comp)
  (if (component-executable? comp) comp
      (make-component (component-ID comp) (component-data comp) (component-procedure comp) #t)))

;;;
;;;; Set comp datum
;;;

(define (%comp-datum-set! comp data)
  (let ((%data (component-data comp)))
    (make-component
     (component-ID comp)
     (let loop ((keys (map car data)))
       (if (null? keys) %data
           (replace!
            (loop (cdr keys))
            (assoc (car keys) %data)
            (assoc (car keys) data))))
     (component-procedure comp)
     (component-executable? comp))))
