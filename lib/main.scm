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
;; Project: Main
;;

(include "comp.scm")
(include "state.scm")
(include "utilities.scm")

;;
;;;; Executable
;;

;; Defining funcitons using define executable allows you to call other executables within that function.


(define THREAD_TIME_OUT 1)
(define (thread-join-default) (error "Thread Timeout occured: " (current-thread)))

(define-macro (define-executable args . body)
  `(define (,(car args) #!key state ,@args)
     ,@body))


;; Should only be called witin the define-executable form to multipthread component executions and inherently use the state

(define-macro (execute s)
  `(raw-execute state ,s))


;;;;
;;;; TESTS
;;;;

(define (state-loop state)
  (let ((sum (raw-execute state 'one)))
    (println "Sum is now " sum)
    (if (= 5 sum) (state-loop (comp-datum-set! state 'one (list (cons 'one (execute 'two)))))
        (state-loop (state-data-set! state (cons 'one (list (cons 'one sum))))))))


(define-executable (add one)
  (thread-sleep! 1)
  (display "Working...")
  (newline)
  (+ one 1))

(define-executable (reset two)
  (println "In add2..")
  two)

(state-loop
 (state-add-all! state (make-executable-comp 'one add (cons 'one 1)) (make-executable-comp 'two reset (cons 'two 1)))
 )
