with source as (
    select 
        *
    from {{ ref('transaction_types') }}
)
select * from source