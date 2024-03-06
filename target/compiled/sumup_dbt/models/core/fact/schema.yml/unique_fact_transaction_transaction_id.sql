
    
    

select
    transaction_id as unique_field,
    count(*) as n_records

from staging.dbt_tanya_bi.fact_transaction
where transaction_id is not null
group by transaction_id
having count(*) > 1


