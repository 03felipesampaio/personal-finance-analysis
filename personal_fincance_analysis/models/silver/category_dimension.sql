with source as (
    select 
        *
    from {{ ref("stg_categories") }}
)
select * from source