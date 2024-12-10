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
            when transaction_description like 'Antecipada %' then 'Antecipated installment'
            when transaction_description like '"Credito de' then 'Refund'
            when transaction_description = 'Crédito de atraso' then 'Late credit'
            when transaction_description = 'Crédito de parcelamento de compra' then 'Installment credit'
            when transaction_description like 'Desconto Antecipação %' then 'Antecipated discount'
            when transaction_description like '"Estorno de %' then 'Refund'
            when transaction_description like '"IOF de %' then 'Fee'
            when transaction_description = 'IOF de atraso' then 'Late payment fee'
            when transaction_description = 'Juros de atraso' then 'Late interest'
            when transaction_description = 'Multa de atraso' then 'Late fee'
            when transaction_description like 'Pagamento em %' then 'Bill payment'
            when transaction_description like '"Parcelamento de compra %' then 'Credit Card'
            when transaction_description = 'Saldo em atraso' then 'Late balance'
            -- Tem muita informação no Ifood que dá pra extrair
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