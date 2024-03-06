select 
    store_typology, 
    store_country,
    round (avg(transaction_amount),2) as avg_transaction_amount
from staging.dbt_tanya_bi.fact_transaction
group by 1,2