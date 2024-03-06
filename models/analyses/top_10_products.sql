with count_transactions as (
    select 
        product_sku,
        count (transaction_id) as count_transactions
    from  {{ ref('fact_transaction' )}}
    group by 1
)

select 
    top 10 *
from count_transactions
order by count_transactions desc