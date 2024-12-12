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
    from {{ source('bronze', 'bills__nubank') }}
)
select * from source