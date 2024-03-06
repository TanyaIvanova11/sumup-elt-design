

with source_data as (

    select 
        id::int as id,
        type::int as type,
        store_id::int as store_id
    from staging.dbt_tanya_bi.device
)

select *
from source_data