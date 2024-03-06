
  create or replace  view staging.dbt_tanya_bi.top_10_products
  
   as (
    with count_transactions as (
    select 
        product_sku,
        count (transaction_id) as count_transactions
    from  staging.dbt_tanya_bi.fact_transaction
    group by 1
)

select 
    top 10 *
from count_transactions
order by count_transactions desc
  );
