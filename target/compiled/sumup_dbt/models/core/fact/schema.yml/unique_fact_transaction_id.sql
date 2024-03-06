
    
    

select
    id as unique_field,
    count(*) as n_records

from staging.dbt_tanya_bi.fact_transaction
where id is not null
group by id
having count(*) > 1


