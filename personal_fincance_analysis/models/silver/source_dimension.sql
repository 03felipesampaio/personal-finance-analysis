with nubank_bills_source as (
    select distinct
        bank_name,
        source_type,
        CAST(NULL as string) as source_account,
        bill_start_date as source_start,
        bill_end_date as source_end,
        bill_date,
        bill_value as bill_amount,
    from {{ ref("stg_bills__nubank") }}
),
inter_bills_source as (
    select distinct
        bank_name,
        source_type,
        CAST(NULL as string) as source_account,
        bill_start_date as source_start,
        bill_end_date as source_end,
        bill_date,
        bill_value as bill_amount,
    from {{ ref("stg_bills_inter") }}
),
nubank_statements_source as (
    select distinct
        bank_name,
        source_type,
        statement_account_id as source_account,
        statement_start_date as source_start,
        statement_end_date as source_end,
        CAST(NULL as date) as bill_date,
        CAST(NULL as numeric) as bill_amount,
    from {{ ref("slv_statements_nubank") }}
),
inter_statements_source as (
    select distinct
        bank_name,
        source_type,
        statement_account_id as source_account,
        statement_start_date as source_start,
        statement_end_date as source_end,
        CAST(NULL as date) as bill_date,
        CAST(NULL as numeric) as bill_amount,
    from {{ ref("slv_statements_inter") }}
),
all_sources as (
    select * from nubank_bills_source
    union all
    select * from inter_bills_source
    union all
    select * from nubank_statements_source
    union all
    select * from inter_statements_source
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