with source as (
    select * from {{ ref('coins') }}
)
select * from source