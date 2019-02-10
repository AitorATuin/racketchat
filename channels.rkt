(module channels typed/racket
  ; channels.rtk
  ; rocket chat /channels API implementation

  (provide channels/info)

  (require "utils.rkt")

  (: channels/info Request)
  (define channels/info (get '("channels.info"))))
