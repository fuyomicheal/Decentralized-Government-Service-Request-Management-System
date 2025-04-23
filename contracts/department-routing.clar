;; Department Routing Contract
;; Directs requests to appropriate agencies

(define-data-var admin principal tx-sender)

;; Map to store departments and their service types
(define-map departments principal
  {
    name: (string-ascii 64),
    service-types: (list 10 (string-ascii 64))
  }
)

;; Map to store request assignments
(define-map request-assignments uint principal)

;; Public function to register a department
(define-public (register-department
                (department principal)
                (name (string-ascii 64))
                (service-types (list 10 (string-ascii 64))))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (map-set departments department
      {
        name: name,
        service-types: service-types
      }
    ))
  )
)

;; Public function to assign a request to a department
(define-public (assign-request (request-id uint) (department principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-some (map-get? departments department)) (err u404))
    (ok (map-set request-assignments request-id department))
  )
)

;; Read-only function to get the department assigned to a request
(define-read-only (get-assigned-department (request-id uint))
  (map-get? request-assignments request-id)
)

;; Read-only function to get department details
(define-read-only (get-department-details (department principal))
  (map-get? departments department)
)

;; Function to transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)
