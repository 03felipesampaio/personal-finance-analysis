with source as (
    select *
    from {{ ref("stg_transaction_types") }}
)
select * from source