;; Message Decryption Contract

(define-data-var next-message-id uint u0)

(define-map encrypted-messages
  { message-id: uint }
  {
    content: (buff 1024),
    decryption-progress: uint,
    status: (string-ascii 20)
  }
)

(define-public (register-encrypted-message (content (buff 1024)))
  (let
    ((message-id (+ (var-get next-message-id) u1)))
    (var-set next-message-id message-id)
    (ok (map-set encrypted-messages
      { message-id: message-id }
      {
        content: content,
        decryption-progress: u0,
        status: "pending"
      }
    ))
  )
)

(define-public (update-decryption-progress (message-id uint) (progress uint))
  (let
    ((message (unwrap! (map-get? encrypted-messages { message-id: message-id }) (err u404))))
    (ok (map-set encrypted-messages
      { message-id: message-id }
      (merge message {
        decryption-progress: progress,
        status: (if (>= progress u100) "decrypted" "in-progress")
      })
    ))
  )
)

(define-read-only (get-encrypted-message (message-id uint))
  (map-get? encrypted-messages { message-id: message-id })
)

