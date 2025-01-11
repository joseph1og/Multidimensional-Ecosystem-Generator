;; Multidimensional Life Forms Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))

;; Data Variables
(define-data-var life-form-counter uint u0)
(define-map life-forms uint {
    name: (string-ascii 50),
    dimension-id: uint,
    genetic-code: (buff 32),
    traits: (list 5 (string-ascii 20)),
    creator: principal
})

;; Public Functions
(define-public (create-life-form (name (string-ascii 50)) (dimension-id uint) (genetic-code (buff 32)) (traits (list 5 (string-ascii 20))))
    (let
        (
            (life-form-id (+ (var-get life-form-counter) u1))
        )
        (asserts! (is-some (contract-call? .dimensional-parameters get-dimension dimension-id)) err-invalid-parameters)
        (map-set life-forms life-form-id {
            name: name,
            dimension-id: dimension-id,
            genetic-code: genetic-code,
            traits: traits,
            creator: tx-sender
        })
        (var-set life-form-counter life-form-id)
        (ok life-form-id)
    )
)

(define-public (evolve-life-form (life-form-id uint) (new-genetic-code (buff 32)) (new-traits (list 5 (string-ascii 20))))
    (let
        (
            (life-form (unwrap! (map-get? life-forms life-form-id) err-invalid-parameters))
        )
        (asserts! (is-eq tx-sender (get creator life-form)) err-owner-only)
        (map-set life-forms life-form-id
            (merge life-form {
                genetic-code: new-genetic-code,
                traits: new-traits
            })
        )
        (ok true)
    )
)

;; Read-only Functions
(define-read-only (get-life-form (life-form-id uint))
    (map-get? life-forms life-form-id)
)

(define-read-only (get-life-form-count)
    (var-get life-form-counter)
)

