;; Environmental Impact Contract
;; Monitors atmospheric mining environmental effects

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_INVALID_READING (err u301))
(define-constant ERR_THRESHOLD_EXCEEDED (err u302))

;; Impact thresholds
(define-constant MAX_CO2_CHANGE u50) ;; Max 5% change
(define-constant MAX_PRESSURE_CHANGE u30) ;; Max 3% change
(define-constant MAX_TEMPERATURE_CHANGE u20) ;; Max 2% change

;; Data structures
(define-map environmental-readings
  { operation-id: uint, reading-id: uint }
  {
    timestamp: uint,
    co2-level: uint,
    pressure: uint,
    temperature: int,
    air-quality-index: uint,
    impact-score: uint
  }
)

(define-map operation-impact-summary
  { operation-id: uint }
  {
    total-readings: uint,
    average-impact-score: uint,
    max-impact-score: uint,
    compliance-status: bool
  }
)

(define-data-var next-reading-id uint u1)

;; Record environmental reading
(define-public (record-reading
  (operation-id uint)
  (co2-level uint)
  (pressure uint)
  (temperature int)
  (air-quality-index uint)
)
  (let (
    (reading-id (var-get next-reading-id))
    (impact-score (calculate-impact-score co2-level pressure temperature air-quality-index))
  )
    (asserts! (> co2-level u0) ERR_INVALID_READING)
    (asserts! (> pressure u0) ERR_INVALID_READING)
    (asserts! (> air-quality-index u0) ERR_INVALID_READING)

    (map-set environmental-readings
      { operation-id: operation-id, reading-id: reading-id }
      {
        timestamp: block-height,
        co2-level: co2-level,
        pressure: pressure,
        temperature: temperature,
        air-quality-index: air-quality-index,
        impact-score: impact-score
      }
    )

    (update-impact-summary operation-id impact-score)
    (var-set next-reading-id (+ reading-id u1))
    (ok reading-id)
  )
)

;; Calculate impact score (simplified)
(define-private (calculate-impact-score (co2 uint) (pressure uint) (temp int) (aqi uint))
  (let (
    (co2-impact (/ (* co2 u25) u100))
    (pressure-impact (/ (* pressure u20) u100))
    (temp-impact (if (> temp 0) (to-uint temp) u0))
    (aqi-impact (/ (* aqi u30) u100))
  )
    (+ co2-impact pressure-impact temp-impact aqi-impact)
  )
)

;; Update impact summary
(define-private (update-impact-summary (operation-id uint) (new-impact-score uint))
  (match (map-get? operation-impact-summary { operation-id: operation-id })
    summary (let (
      (new-total (+ (get total-readings summary) u1))
      (new-average (/ (+ (* (get average-impact-score summary) (get total-readings summary)) new-impact-score) new-total))
      (new-max (if (> new-impact-score (get max-impact-score summary)) new-impact-score (get max-impact-score summary)))
    )
      (map-set operation-impact-summary
        { operation-id: operation-id }
        {
          total-readings: new-total,
          average-impact-score: new-average,
          max-impact-score: new-max,
          compliance-status: (<= new-max u100)
        }
      )
    )
    (map-set operation-impact-summary
      { operation-id: operation-id }
      {
        total-readings: u1,
        average-impact-score: new-impact-score,
        max-impact-score: new-impact-score,
        compliance-status: (<= new-impact-score u100)
      }
    )
  )
)

;; Get environmental reading
(define-read-only (get-reading (operation-id uint) (reading-id uint))
  (map-get? environmental-readings { operation-id: operation-id, reading-id: reading-id })
)

;; Get impact summary
(define-read-only (get-impact-summary (operation-id uint))
  (map-get? operation-impact-summary { operation-id: operation-id })
)

;; Check compliance
(define-read-only (is-compliant (operation-id uint))
  (match (map-get? operation-impact-summary { operation-id: operation-id })
    summary (get compliance-status summary)
    true
  )
)
