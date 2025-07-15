{{ config(materialized='table') }}

SELECT
  sponsor_class,
  COUNT_IF(overall_status IN ('TERMINATED', 'WITHDRAWN', 'SUSPENDED')) AS early_stopped_trials,
  COUNT_IF(overall_status IN ('COMPLETED', 'Terminated', 'WITHDRAWN', 'SUSPENDED')) AS total_closed_trials,
  ROUND(
    COUNT_IF(overall_status IN ('TERMINATED', 'WITHDRAWN', 'SUSPENDED'))::FLOAT
    / NULLIF(COUNT_IF(overall_status IN ('COMPLETED', 'TERMINATED', 'WITHDRAWN', 'SUSPENDED')), 0),
    3
  ) AS early_stop_rate
FROM {{ ref('stg_ctgov__studies') }}
GROUP BY sponsor_class
