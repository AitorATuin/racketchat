(module users typed/racket
  ; users.rtk
  ; rocket chat /user API implementation

  (provide users/list users/get-presence users/get-preferences)

  (require "utils.rkt")

  (define users/list : Request (get '("users.list")))

  (define users/get-presence : Request (get '("users.getPresence")))

  (define users/get-preferences : Request (get '("users.getPreferences")))

  (struct None ())
  (struct (a) Some ([v : a]))
  (define-type (Option a) (U None (Some a)))

  (: users/get-avatar (-> [#:username (Option String)]
                          [#:user-id (Option String)]
                          Request))
  (define (users/get-avatar #:username [username (None)]
                            #:user-id [user-id (None)])
    (match `(,username ,user-id)
      [(list (None) (Some a)) (get '("users.getAvatar"))]
      [(list (Some a) (None)) (get '("users.getAvatar"))]
      [(list _ _) (get '("users.getAvatar"))])))
    ;; (match (list username user-id) 
    ;;   [(list None None) (get '("users.getAvatar1"))]
    ;;   [(list (Some id) None) (get '("users.getAvatar2"))]
    ;;   [(list None (Some id)) (get '("users.getAvetar3"))])))
