{{ config(materialized='table') }}

with source_data as (

    select 
        id::int as id,
        type::int as type,
        store_id::int as store_id
    from {{ ref('device') }}
)

select *
from source_data
