#lang racket

(define (check-temps1 temps)
  (check-temps temps 5 95))

(define (check-temps temps low high)
  (if (empty? temps)
   true
  (cond
  [(< (first temps) low) false]
  [(> (first temps) high) false]
  [else (check-temps1 (rest temps))])))

(define (convert digits)
  (if (empty? digits)
   0
  (+ (first digits) (* 10 (convert(rest digits))))))

(define (duple lst)
  (if (empty? lst)
  (list)
  (cons (list (first lst) (first lst)) (duple (rest lst)))))

(define (sum lst)
  (if (empty? lst)
   0
  (+ (first lst) (sum (rest lst)))))

(define (average lst)
  (if (empty? lst)
   0
  (/ (sum lst) (length lst))))

(define (convertFC temps)
  (if (empty? temps)
   null
  (cons (/ (- (first temps) 32) 9/5) (convertFC (rest temps)))))

(define (isSmallest lst num)
  (if (empty? lst)
   true
  (if (> num (first lst))
      false
      (isSmallest (rest lst) num))))

(define (eliminate-larger lst)
  (if (empty? lst)
  (list)
  (if (isSmallest (rest lst) (first lst))
  (cons (first lst) (eliminate-larger (rest lst)))
  (eliminate-larger (rest lst)))))
     
(define (get-nth lst n)
  (cond
  [(empty? lst) null]
  [(equal? n 0) (first lst)]
  [else (get-nth (rest lst) (- n 1))]))

(define (find-item lst target)
  (find-item-aux lst target 0))

(define (find-item-aux lst target num)
  (cond
  [(empty? lst) -1]
  [(equal? (first lst) target) num]
  [else (find-item-aux (rest lst) target (+ num 1))]))