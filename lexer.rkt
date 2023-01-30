#lang racket/base

(require brag/support
         racket/function)

(provide make-tokenizer)

(define bf-lexer
  (lexer-srcloc
   [(char-set "><+-,.[]") lexeme]
   [any-char (bf-lexer input-port)]))

(define (make-tokenizer port [path #f])
  (port-count-lines! port)
  (lexer-file-path path)
  (thunk (bf-lexer port)))
