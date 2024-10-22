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
;; Project: State file for gadux system
;;


;;;
;;;; Default structs
;;;

(define-structure state executable data)

(define state (make-state (list) (list)))

;;;
;;;; States
;;;

(define states (list))

;;;
;;;; State ref
;;;

(define (state-ref state ID #!key (executable? #t))
  (assoc ID (if executable? (state-executable state) (state-data state))))

;;;
;;;; State Add
;;;

(define (state-add! state comp)
  (if (component-executable? comp)
      (make-state
       (replace! (state-executable state) (state-ref state (component-ID comp)) (cons (component-ID comp) comp))
       (state-data state))
      (make-state
       (state-executable state)
       (replace! (state-data state) (state-ref state (component-ID comp) executable?: #f) (cons (component-ID comp) comp)))))

(define (state-add-all! state . comps)
  (let loop ((comps comps))
    (if (null? comps) state
        (state-add! (loop (cdr comps)) (car comps)))))

;;;
;;;; Comp Datum Set
;;;

(define (comp-datum-set! state ID . data)
  (let ((comp-pair (state-ref state ID)))
    (if comp-pair (apply %comp-datum-set! (list (cdr comp-pair) data)))))

;;;
;;;; Execute
;;;

(define (raw-execute state ID)
  (let ((comp-pair (state-ref state ID)))
    (if comp-pair (%execute state (cdr comp-pair)))))
