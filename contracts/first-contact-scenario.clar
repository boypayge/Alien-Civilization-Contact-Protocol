;; First Contact Scenario Contract

(define-data-var next-scenario-id uint u0)

(define-map scenarios
  { scenario-id: uint }
  {
    description: (string-utf8 1024),
    protocol: (string-utf8 2048),
    status: (string-ascii 20)
  }
)

(define-public (create-scenario (description (string-utf8 1024)) (protocol (string-utf8 2048)))
  (let
    ((scenario-id (+ (var-get next-scenario-id) u1)))
    (var-set next-scenario-id scenario-id)
    (ok (map-set scenarios
      { scenario-id: scenario-id }
      {
        description: description,
        protocol: protocol,
        status: "draft"
      }
    ))
  )
)

(define-public (update-scenario-status (scenario-id uint) (new-status (string-ascii 20)))
  (let
    ((scenario (unwrap! (map-get? scenarios { scenario-id: scenario-id }) (err u404))))
    (ok (map-set scenarios
      { scenario-id: scenario-id }
      (merge scenario { status: new-status })
    ))
  )
)

(define-public (update-scenario-protocol (scenario-id uint) (new-protocol (string-utf8 2048)))
  (let
    ((scenario (unwrap! (map-get? scenarios { scenario-id: scenario-id }) (err u404))))
    (ok (map-set scenarios
      { scenario-id: scenario-id }
      (merge scenario { protocol: new-protocol })
    ))
  )
)

(define-read-only (get-scenario (scenario-id uint))
  (map-get? scenarios { scenario-id: scenario-id })
)

