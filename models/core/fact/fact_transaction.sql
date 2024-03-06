{{ config(
    materialized = 'table'
) }} 

-- should have materialized = 'incremental' in case large data volums are coming reguraly via the source, then config as following:
-- config(
--     materialized='incremental',
--     unique_key = 'id'
-- ) 


with base as (

    select
        tr.id::int as transaction_id,
        device_id::int as device_id,
        product_name,
        product_sku,
        category_name,
        amount as transaction_amount,
        status as transaction_status,
        card_number,
        cvv,
        tr.created_at::timestamp_ntz as transaction_created_at,
        happened_at::timestamp_ntz as transaction_happened_at,
        dv.type as device_type, 
        dv.store_id as store_id, 
        st.name as store_name,
        st.country as store_country,
        st.typology as store_typology, 
        st.created_at as store_created_at,
        row_number() over (partition by transaction_id order by transaction_created_at desc) as deduplication --in case of incremental materialization the deduplication should be done is an additional 'raw' model before the fact model
    from {{ ref('transaction') }} as tr
    left join {{ ref('dim_device') }} as dv on tr.device_id = dv.id
    left join {{ ref('dim_store') }} as st on dv.store_id = st.id

    -- in case materialized = 'incremental' then apply following: 

    -- {% if is_incremental() %} 

    -- where happened_at > (select max(happened_at) from {{ this }})
    
    -- {% endif %}
)

select *
from base
where deduplication = 1