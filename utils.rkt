(module utils typed/racket
  ; utils.rtk
  ; Utilities

  (provide auth connection mk-connection connection->url get
           connection->header Response Request UrlPath)

  ; -------------------------------------------

  (require typed/net/url)
  (require typed/json)

  (define-type UrlPath (Listof String))

  (struct auth ([token : String]
                [id : String]))

  (struct connection ([host : String]
                      [port : Integer]
                      [base-path : UrlPath]
                      [auth : auth]))

  (: mk-connection (-> auth [#:host String] [#:port Integer] [#:path UrlPath]
                       connection))
  (define (mk-connection auth
                         #:host [host "localhost"]
                         #:port [port 3000]
                         #:path [path '("api" "v1")])
    (connection host port path auth))

  (: connection->url (-> connection UrlPath url))
  (define (connection->url c p)
    (define url (format "http://~a:~a/~a/~a"
                        (connection-host c)
                        (connection-port c)
                        (string-join (connection-base-path c) "/")
                        (string-join p "/")))
    (string->url url))

  (: connection->header (-> connection (Listof String)))
  (define (connection->header c)
    `(,(~a "X-Auth-Token: " (auth-token (connection-auth c)))
      ,(~a "X-User-Id: " (auth-id (connection-auth c)))))

  (define-type Response (U EOF JSExpr))
  (define-type Request (-> connection Response))

  (: get (-> UrlPath Request))
  (define (get path)
    (λ (c)
      (define url (connection->url c path))
      (define auth-headers (connection->header c))
      (call/input-url url get-pure-port read-json auth-headers))))
