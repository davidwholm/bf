#lang racket/base

(require brag/support)

(provide color-bf)

(define color-bf
  (lexer
   [(eof) (values lexeme 'eof #f #f #f)]
   [(char-set "><+-,.") (values lexeme 'symbol #f (pos lexeme-start) (pos lexeme-end))]
   [(:or "[" "]") (values lexeme 'parenthesis (if (equal? lexeme "[")
                                                  '|(| '|)|) (pos lexeme-start) (pos lexeme-end))]
   [whitespace (values lexeme 'white-space #f (pos lexeme-start) (pos lexeme-end))]
   [any-char (values lexeme 'comment #f (pos lexeme-start) (pos lexeme-end))]))