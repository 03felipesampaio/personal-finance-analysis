with source as (
    select * from {{ source('bronze', 'places') }}
)
select * from source