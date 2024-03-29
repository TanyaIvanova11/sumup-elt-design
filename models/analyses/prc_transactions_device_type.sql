with count_transactions as( 
    select 
        device_type,
        count (transaction_id) as count_transactions
    from {{ ref('fact_transaction' )}}
    group by 1
)

select 
    device_type,
    count_transactions,
    sum(count_transactions) over () as total_count_transactions,
    count_transactions/total_count_transactions as prc_transactions
from count_transactions

