with time_5_transactions as (
    select 
    store_id,
    store_created_at,
    transaction_happened_at,
    lead(transaction_happened_at,4) over (partition by store_id order by transaction_happened_at ) as created_to_5_transaction_duration,
    datediff(day, transaction_happened_at, lead(transaction_happened_at,4) over (partition by store_id order by transaction_happened_at ) ) as days_to_5_transaction
    from {{ ref('fact_transaction' )}}
    qualify row_number() over (partition by store_id order by transaction_happened_at) = 1
)

select 
round(avg(days_to_5_transaction)) as avg_time_to_5_transaction_days
from time_5_transactions



