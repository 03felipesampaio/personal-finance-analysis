with source as (
    select 
        *
    from {{ source('bronze', 'transaction_types') }}
)
select * from source