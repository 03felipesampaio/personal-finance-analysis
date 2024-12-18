with source as (
    select 
        bank_name,
        'Credit Card Bill' as source_type,
        bill_date,
        bill_reference_month,
        bill_value,
        bill_start_date,
        bill_end_date,
        transaction_date,
        case
            when transaction_description like 'Pagamento On Line' then 'Bill payment'
            when transaction_description like 'PAGAMENTO ON LINE' then 'Bill payment'
            when transaction_description like 'PAGTO DEBITO AUTOMATICO' then 'Bill payment'
            when transaction_description like 'Pagto Debito Automatico' then 'Bill payment'
            -- Tem muita informação no Ifood que dá pra extrair
            -- when regexp_contains(transaction_description, r' - \d+/\d+') then 'Credit card parcell'
            else 'Credit card' end
        as transaction_type,
        transaction_description,
        transaction_value,
        transaction_category 
    from {{ source('bronze', 'bills__inter') }}
)
select * from source