#lang racket

(define (convertFC temps)
  (map (lambda (x) (* (- x 32) 5/9)) temps))

(define (check-temps1 temps)
  (check-temps temps 5 95))

(define (check-temps temps low high)
    (andmap (lambda (x) (cond
                     [(< x low) false]
                     [(> x high) false]
                     [else true])) temps))

(define (convert digits)
  (foldr (lambda (x y) (+ x (* 10 y))) 0 digits))

(define (duple lst)
  (map (lambda (x) (list x x)) lst))

(define (average lst)
  (/ (foldr + 0 lst) (length lst)))

(define (eliminate-larger lst)
  (foldr (lambda (x y) (cond
                       [(empty? y) (cons x y)]     
                       [(< x (first y)) (cons x y)]
                       [else y])) '() lst))

(define (curry2 func)
  (lambda (x)
    (lambda (y)
      (func x y))))