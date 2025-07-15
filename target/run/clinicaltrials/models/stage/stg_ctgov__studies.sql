
  
    

create or replace transient table DB_CLINICAL_TRIALS_GOV.sh_clinical_trials_gov_stage.stg_ctgov__studies
    
    
    
    as (

WITH raw AS (
  SELECT
    payload:protocolSection.identificationModule.nctId::STRING AS nct_id,
    payload:protocolSection.statusModule.overallStatus::STRING AS overall_status,
    payload:protocolSection.sponsorCollaboratorsModule.leadSponsor.class::STRING AS sponsor_class,
    payload:protocolSection.statusModule.completionDateStruct.date::STRING AS completion_date,
    payload:protocolSection.statusModule.primaryCompletionDateStruct.date::STRING AS primary_completion_date,
    payload:protocolSection.statusModule.studyFirstSubmitDate::DATE AS first_submit_date,
    payload:protocolSection.designModule.studyType::STRING AS study_type,
    payload:protocolSection.designModule.phases[0]::STRING AS phase
  FROM DB_CLINICAL_TRIALS_GOV.SH_CLINICAL_TRIALS_GOV_RAW.RAW_CTGOV__STUDIES
)
SELECT
  nct_id,
  overall_status,
  completion_date,
  sponsor_class,
  study_type,
  phase,
  primary_completion_date,
  first_submit_date
FROM raw
/*WHERE study_type = 'Interventional'
  AND phase IN ('Phase 2', 'Phase 3')
  AND first_submit_date >= '2015-01-01'
*/
    )
;


  