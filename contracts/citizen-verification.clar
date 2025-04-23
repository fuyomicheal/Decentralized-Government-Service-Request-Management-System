;; Citizen Verification Contract
;; This contract validates the identity of service requestors

(define-data-var admin principal tx-sender)

;; Map to store verified citizens
(define-map verified-citizens principal
  {
    verified: bool,
    verification-date: uint,
    verification-level: uint
  }
)

;; Public function to verify a citizen
(define-public (verify-citizen (citizen principal) (verification-level uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (map-set verified-citizens citizen
      {
        verified: true,
        verification-date: block-height,
        verification-level: verification-level
      }
    ))
  )
)

;; Public function to revoke verification
(define-public (revoke-verification (citizen principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (map-delete verified-citizens citizen))
  )
)

;; Read-only function to check if a citizen is verified
(define-read-only (is-citizen-verified (citizen principal))
  (default-to
    { verified: false, verification-date: u0, verification-level: u0 }
    (map-get? verified-citizens citizen)
  )
)

;; Function to transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)
