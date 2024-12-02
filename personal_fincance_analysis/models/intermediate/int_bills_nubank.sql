with bills_raw as (
    select *
    from {{ ref('stg_bills__nubank') }}
),
bills_with_transaction_type as (
    select
        bank_name,
        bill_date,
        bill_reference_month,
        bill_value,
        bill_start_date,
        bill_end_date,
        transaction_date,

        case
            when transaction_description like 'Pagamento em %' then 'Bill payment'
            when transaction_description = 'IOF de atraso' then 'Late payment fee'
            -- There is also r'IOF de \w+' for international purchases
            -- when regexp_contains(transaction_description, r' - \d+/\d+') then 'Credit card parcell'
            else 'Credit card' end
        as transaction_type,

        transaction_description,
        transaction_value,
        transaction_category

    from bills_raw
),
bills_with_location as (
    select
        *,
        -- The locations are in the description, if the transactions has installments we need to remove it
        case
            when transaction_type = 'Credit card' then regexp_replace(transaction_description, r' - \d+/\d+\s*$', '')
            else 'Nubank' end
        as transaction_location
    from bills_with_transaction_type
    -- where transaction_description = 'Credit card'
)
select * from bills_with_location