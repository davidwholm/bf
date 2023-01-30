#lang racket/base

(require syntax/parse/define
         (for-syntax racket/base))

(provide #%module-begin #%datum #%top
         bf-program bf-op bf-loop)

(define stack (make-vector 30000 0))
(define pointer 0)

(define (increment-pointer!)
  (unless (< pointer (sub1 (vector-length stack)))
    (error '> "out of bounds"))
  (set! pointer (add1 pointer)))

(define (decrement-pointer!)
  (unless (> pointer 0)
    (error '< "out of bounds"))
  (set! pointer (sub1 pointer)))

(define (increment-byte!)
  (vector-set! stack pointer (add1 (vector-ref stack pointer))))

(define (decrement-byte!)
  (vector-set! stack pointer (sub1 (vector-ref stack pointer))))

(define (read-byte!)
  (vector-set! stack pointer (read-byte)))

(define (write-byte!)
  (write-byte (vector-ref stack pointer)))

(define-syntax-parser bf-program
  [(_ op/loop ...)
   (syntax/loc this-syntax
     (void op/loop ...))])

(define-syntax-parser bf-op
  [(_ ">")
   (syntax/loc this-syntax
     (increment-pointer!))]
  [(_ "<")
   (syntax/loc this-syntax
     (decrement-pointer!))]
  [(_ "+")
   (syntax/loc this-syntax
     (increment-byte!))]
  [(_ "-")
   (syntax/loc this-syntax
     (decrement-byte!))]
  [(_ ",")
   (syntax/loc this-syntax
     (read-byte!))]
  [(_ ".")
   (syntax/loc this-syntax
     (write-byte!))])

(define-syntax-parser bf-loop
  [(_ "[" op/loop ... "]")
   (syntax/loc this-syntax
     (let loop ()
       (unless (zero? (vector-ref stack pointer))
         op/loop ...
         (loop))))])