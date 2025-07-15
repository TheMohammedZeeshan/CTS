
  
    

create or replace transient table DB_CLINICAL_TRIALS_GOV.sh_clinical_trials_gov_cur.int_sponsor_summary
    
    
    
    as (

SELECT
  sponsor_class,
  COUNT_IF(overall_status IN ('TERMINATED', 'WITHDRAWN', 'SUSPENDED')) AS early_stopped_trials,
  COUNT_IF(overall_status IN ('COMPLETED', 'Terminated', 'WITHDRAWN', 'SUSPENDED')) AS total_closed_trials,
  ROUND(
    COUNT_IF(overall_status IN ('TERMINATED', 'WITHDRAWN', 'SUSPENDED'))::FLOAT
    / NULLIF(COUNT_IF(overall_status IN ('COMPLETED', 'TERMINATED', 'WITHDRAWN', 'SUSPENDED')), 0),
    3
  ) AS early_stop_rate
FROM DB_CLINICAL_TRIALS_GOV.sh_clinical_trials_gov_stage.stg_ctgov__studies
GROUP BY sponsor_class
    )
;


  