with nubank_bills_source as (
    select distinct
        bank_name,
        'Credit Card Bill' as source_type,
        NULL as source_account,
        bill_start_date as source_start,
        bill_end_date as source_end,
        bill_date,
        bill_value as bill_amount,
    from {{ ref("stg_bills__nubank") }}
),
all_sources as (
    select * from nubank_bills_source
    {# Union from here #}
)
select
    ABS(FARM_FINGERPRINT(CONCAT(bank_name, source_type, source_start, source_end))) AS source_id,
    bank_name,
    source_type,
    source_account,
    source_start,
    source_end,
    bill_date,
    bill_amount
from all_sources