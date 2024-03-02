{{ config(materialized='table') }}

with source_data as (

    select 
        * 
    from {{ ref('store') }}

)

select *
from source_data

