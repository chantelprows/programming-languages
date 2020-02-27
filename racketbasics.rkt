#lang racket
(define (sum-coins pennies nickels dimes quarters)
        (+ pennies (* nickels 5) (* dimes 10) (* quarters 25)))

(define (degrees-to-radians angle)
        (* (/ angle 180) pi))

(define (sign x)
        (cond
        [(positive? x) 1]
        [(zero? x) 0]
        [(negative? x) -1]))

(define (new-sin angle type)
        (cond
        [(symbol=? type 'degrees) (sin (degrees-to-radians angle))]
        [(symbol=? type 'radians) (sin angle)]))