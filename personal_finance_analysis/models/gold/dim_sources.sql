with
source as (
    select
        source_id,
        bank_name,
        source_type,
        source_account,
        source_start,
        source_end,
        bill_date,
        bill_amount
    from {{ ref('slv_dim_sources') }}
)

select * from source
