;; Simulation Resource Token Contract (FT)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))

;; Fungible Token Definition
(define-fungible-token simulation-resource)

;; Data Variables
(define-data-var token-uri (string-utf8 256) u"https://example.com/simulation-resource-metadata")

;; Public Functions
(define-public (mint (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ft-mint? simulation-resource amount recipient)
    )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) err-not-authorized)
        (ft-transfer? simulation-resource amount sender recipient)
    )
)

;; Read-only Functions
(define-read-only (get-balance (account principal))
    (ft-get-balance simulation-resource account)
)

(define-read-only (get-total-supply)
    (ft-get-supply simulation-resource)
)

(define-read-only (get-token-uri)
    (ok (var-get token-uri))
)

;; SIP-010 Functions
(define-public (transfer-ft (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-not-authorized)
        (ft-transfer? simulation-resource amount tx-sender recipient)
    )
)

(define-read-only (get-name)
    (ok "Simulation Resource Token")
)

(define-read-only (get-symbol)
    (ok "SIMRES")
)

(define-read-only (get-decimals)
    (ok u6)
)

