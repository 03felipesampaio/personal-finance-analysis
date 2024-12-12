with source as (
    select * from {{ source('bronze', 'coins') }}
)
select * from source