;; Dimensional Parameters Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))

;; Data Variables
(define-data-var dimension-counter uint u0)
(define-map dimensions uint {
    name: (string-ascii 50),
    spatial-dimensions: uint,
    time-dimensions: uint,
    physical-constants: (list 10 int),
    creator: principal
})

;; Public Functions
(define-public (create-dimension (name (string-ascii 50)) (spatial-dims uint) (time-dims uint) (constants (list 10 int)))
    (let
        (
            (dimension-id (+ (var-get dimension-counter) u1))
        )
        (asserts! (and (> spatial-dims u0) (> time-dims u0)) err-invalid-parameters)
        (map-set dimensions dimension-id {
            name: name,
            spatial-dimensions: spatial-dims,
            time-dimensions: time-dims,
            physical-constants: constants,
            creator: tx-sender
        })
        (var-set dimension-counter dimension-id)
        (ok dimension-id)
    )
)

(define-public (update-dimension (dimension-id uint) (new-constants (list 10 int)))
    (let
        (
            (dimension (unwrap! (map-get? dimensions dimension-id) err-invalid-parameters))
        )
        (asserts! (is-eq tx-sender (get creator dimension)) err-owner-only)
        (map-set dimensions dimension-id
            (merge dimension {
                physical-constants: new-constants
            })
        )
        (ok true)
    )
)

;; Read-only Functions
(define-read-only (get-dimension (dimension-id uint))
    (map-get? dimensions dimension-id)
)

(define-read-only (get-dimension-count)
    (var-get dimension-counter)
)

