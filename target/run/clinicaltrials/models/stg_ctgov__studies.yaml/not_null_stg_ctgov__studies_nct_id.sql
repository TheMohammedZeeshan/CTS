
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select nct_id
from DB_CLINICAL_TRIALS_GOV.sh_clinical_trials_gov_stage.stg_ctgov__studies
where nct_id is null



  
  
      
    ) dbt_internal_test