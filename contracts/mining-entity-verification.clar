;; Mining Entity Verification Contract
;; Validates and manages atmospheric mining operations

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ENTITY_EXISTS (err u101))
(define-constant ERR_ENTITY_NOT_FOUND (err u102))
(define-constant ERR_INVALID_STATUS (err u103))

;; Entity status types
(define-constant STATUS_PENDING u0)
(define-constant STATUS_VERIFIED u1)
(define-constant STATUS_SUSPENDED u2)
(define-constant STATUS_REVOKED u3)

;; Data structures
(define-map mining-entities
  { entity-id: uint }
  {
    owner: principal,
    name: (string-ascii 64),
    license-number: (string-ascii 32),
    status: uint,
    verification-date: uint,
    expiry-date: uint
  }
)

(define-data-var next-entity-id uint u1)

;; Register a new mining entity
(define-public (register-entity (name (string-ascii 64)) (license-number (string-ascii 32)))
  (let ((entity-id (var-get next-entity-id)))
    (asserts! (is-none (map-get? mining-entities { entity-id: entity-id })) ERR_ENTITY_EXISTS)
    (map-set mining-entities
      { entity-id: entity-id }
      {
        owner: tx-sender,
        name: name,
        license-number: license-number,
        status: STATUS_PENDING,
        verification-date: u0,
        expiry-date: u0
      }
    )
    (var-set next-entity-id (+ entity-id u1))
    (ok entity-id)
  )
)

;; Verify an entity (admin only)
(define-public (verify-entity (entity-id uint) (expiry-date uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? mining-entities { entity-id: entity-id })
      entity (begin
        (map-set mining-entities
          { entity-id: entity-id }
          (merge entity {
            status: STATUS_VERIFIED,
            verification-date: block-height,
            expiry-date: expiry-date
          })
        )
        (ok true)
      )
      ERR_ENTITY_NOT_FOUND
    )
  )
)

;; Get entity details
(define-read-only (get-entity (entity-id uint))
  (map-get? mining-entities { entity-id: entity-id })
)

;; Check if entity is verified
(define-read-only (is-entity-verified (entity-id uint))
  (match (map-get? mining-entities { entity-id: entity-id })
    entity (is-eq (get status entity) STATUS_VERIFIED)
    false
  )
)
