select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select id
from staging.dbt_tanya_bi.fact_transaction
where id is null



      
    ) dbt_internal_test