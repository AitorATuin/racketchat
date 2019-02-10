(module user typed/racket
  ; user.rtk
  ; rocket chat /user API implementation

  (provide user/me)

  (require "utils.rkt")

  (: user/me Request)
  (define user/me (get '("me"))))
