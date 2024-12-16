with source as (
    select * from {{ source('bronze', 'bills__inter') }}
)
select * from source