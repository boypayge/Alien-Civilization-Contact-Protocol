;; Response Formulation Contract

(define-data-var next-response-id uint u0)

(define-map responses
  { response-id: uint }
  {
    content: (string-utf8 1024),
    author: principal,
    votes: uint,
    status: (string-ascii 20)
  }
)

(define-public (submit-response (content (string-utf8 1024)))
  (let
    ((response-id (+ (var-get next-response-id) u1)))
    (var-set next-response-id response-id)
    (ok (map-set responses
      { response-id: response-id }
      {
        content: content,
        author: tx-sender,
        votes: u0,
        status: "proposed"
      }
    ))
  )
)

(define-public (vote-on-response (response-id uint))
  (let
    ((response (unwrap! (map-get? responses { response-id: response-id }) (err u404))))
    (ok (map-set responses
      { response-id: response-id }
      (merge response { votes: (+ (get votes response) u1) })
    ))
  )
)

(define-public (update-response-status (response-id uint) (new-status (string-ascii 20)))
  (let
    ((response (unwrap! (map-get? responses { response-id: response-id }) (err u404))))
    (ok (map-set responses
      { response-id: response-id }
      (merge response { status: new-status })
    ))
  )
)

(define-read-only (get-response (response-id uint))
  (map-get? responses { response-id: response-id })
)

