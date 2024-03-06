with total_amount as (
    select 
        store_id, 
        sum (transaction_amount)  as total_amount
    from  {{ ref('fact_transaction' )}}
    group by 1
)

select 
    top 10 *
from total_amount
order by total_amount desc