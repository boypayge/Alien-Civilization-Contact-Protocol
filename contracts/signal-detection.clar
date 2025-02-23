;; Signal Detection Contract

(define-data-var next-signal-id uint u0)

(define-map signals
  { signal-id: uint }
  {
    frequency: uint,
    strength: uint,
    timestamp: uint,
    status: (string-ascii 20)
  }
)

(define-public (register-signal (frequency uint) (strength uint))
  (let
    ((signal-id (+ (var-get next-signal-id) u1)))
    (var-set next-signal-id signal-id)
    (ok (map-set signals
      { signal-id: signal-id }
      {
        frequency: frequency,
        strength: strength,
        timestamp: block-height,
        status: "unverified"
      }
    ))
  )
)

(define-public (update-signal-status (signal-id uint) (new-status (string-ascii 20)))
  (let
    ((signal (unwrap! (map-get? signals { signal-id: signal-id }) (err u404))))
    (ok (map-set signals
      { signal-id: signal-id }
      (merge signal { status: new-status })
    ))
  )
)

(define-read-only (get-signal (signal-id uint))
  (map-get? signals { signal-id: signal-id })
)

