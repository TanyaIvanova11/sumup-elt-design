

with source_data as (

    select 
        id::int as id, 
        name::varchar(128) as name,
        address::varchar(256) as address,
        city::varchar(128) as city,
        country::varchar(128) as country,
        created_at::timestamp_ntz as created_at,
        typology::varchar(128) as typology,
        customer_id::int as customer_id
    from staging.dbt_tanya_bi.store
)

select *
from source_data