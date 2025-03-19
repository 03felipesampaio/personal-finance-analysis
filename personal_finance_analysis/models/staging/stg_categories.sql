with source as (
    select 
        *
    from {{ ref('categories') }}
)
select * from source