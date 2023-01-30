#lang racket/base

(require "lexer.rkt"
         "parser.rkt"
         "colorer.rkt"
         syntax/strip-context)

(provide (rename-out [bf-read-syntax read-syntax]
                     [bf-get-info get-info]))

(define (bf-read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port path)))
  (strip-context
   #`(module bf-mod bf/expander
       #,parse-tree)))

(define (bf-get-info port mod line col pos)
  (λ (key default)
    (case key
      [(color-lexer)
       (dynamic-require 'bf/colorer 'color-bf)]
      [else default])))