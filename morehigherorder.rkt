#lang racket

(define (default-parms f values)
  (lambda args
      (if (equal? (length values) (length args))
          (apply f args)
          (apply f (append args (list-tail values
                                           (length args)))))))
(define (same-params? types args)
  (if (empty? args)
    true
  (cond    
    [((first types) (first args))
                   (same-params? (rest types) (rest args))]
    [else false])))
  
(define (type-parms f types)
  (lambda args
    (if (same-params? types args)
        (apply f args)
        (error "ERROR MSG"))))

(define (degrees-to-radians angle)
        (* (/ angle 180) pi))

(define (new-sin angle type)
        (cond
        [(symbol=? type 'degrees) (sin (degrees-to-radians angle))]
        [(symbol=? type 'radians) (sin angle)]))

(define new-sin2 (default-parms
                   (type-parms new-sin (list number? symbol?))
                   (list 0 'radians)))