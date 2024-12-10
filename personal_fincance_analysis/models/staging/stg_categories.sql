with source as (
    select 
        *
    from {{ source('bronze', 'categories') }}
)
select * from source