with source as (
    select *
    from {{ source('bronze', 'bills__nubank') }}
)
select * from source