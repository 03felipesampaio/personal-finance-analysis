{{ config(
    materialized='table'
) }}

-- I want to create a staging table for transactions
-- The idea is to join all sources here, so they have the same structure
-- and then I can create the silver table

with bills_nubank as (
    select
        bill.bank_name,
        bill.source_type,
        bill.bill_start_date as source_start,
        bill.bill_end_date as source_end,

        bill.transaction_type,

        bill.transaction_date,
        bill.transaction_description,
        bill.transaction_category,
        bill.coin_code,
        bill.transaction_value * -1 as amount

    from {{ ref('stg_bills__nubank') }} as bill
),

bills_inter as (
    select
        bill.bank_name,
        bill.source_type,
        bill.bill_start_date as source_start,
        bill.bill_end_date as source_end,

        bill.transaction_type,

        bill.transaction_date,
        bill.transaction_description,
        bill.transaction_category,
        bill.coin_code,
        bill.transaction_value * -1 as amount

    from {{ ref('stg_bills_inter') }} as bill
),

statements_nubank as (
    select
        bank_name,
        source_type,
        statement_start_date as source_start,
        statement_end_date as source_end,

        transaction_type,

        transaction_date,
        transaction_description,
        transaction_category,
        coin_code,
        transaction_value as amount

    from {{ ref('stg_statements_nubank') }}
),

statements_inter as (
    select
        bank_name,
        source_type,
        statement_start_date as source_start,
        statement_end_date as source_end,

        transaction_type,

        transaction_date,
        transaction_description,
        transaction_category,
        coin_code,
        transaction_value as amount

    from {{ ref('stg_statements_inter') }}
),

all_sources as (
    select
        bank_name,
        source_type,
        source_start,
        source_end,
        transaction_type,
        transaction_date,
        transaction_description,
        transaction_category,
        coin_code,
        amount
    from bills_nubank

    union all

    select
        bank_name,
        source_type,
        source_start,
        source_end,
        transaction_type,
        transaction_date,
        transaction_description,
        transaction_category,
        coin_code,
        amount
    from bills_inter

    union all

    select
        bank_name,
        source_type,
        source_start,
        source_end,
        transaction_type,
        transaction_date,
        transaction_description,
        transaction_category,
        coin_code,
        amount
    from statements_nubank

    union all

    select
        bank_name,
        source_type,
        source_start,
        source_end,
        transaction_type,
        transaction_date,
        transaction_description,
        transaction_category,
        coin_code,
        amount
    from statements_inter
),

all_sources_with_id as (
    select
        *,
        abs(farm_fingerprint(
            concat(
                bank_name,
                source_type,
                source_start,
                source_end
            )
        )) as source_id
    from all_sources
)

select
    {{ generate_transaction_id('transaction_date', 'source_id', 'transaction_description', 'amount') }} as transaction_id, -- noqa:
    source_id,
    bank_name,
    source_type,
    source_start,
    source_end,
    transaction_date,
    transaction_type,
    transaction_description,
    transaction_category,
    coin_code,
    amount
from all_sources_with_id
