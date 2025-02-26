with source as (
    select * from {{ ref('places') }}
)
select * from source