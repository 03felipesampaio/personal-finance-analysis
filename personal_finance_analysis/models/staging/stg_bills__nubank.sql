with source as (
    select
        bank_name,
        bill_date,
        bill_reference_month,
        bill_value,
        bill_start_date,
        bill_end_date,
        transaction_date,
        transaction_value,
        transaction_category,
        trim(transaction_description) as transaction_description
    from {{ source('bronze', 'bills__nubank') }}
),

source_with_types as (
    select
        bank_name,
        bill_date,
        bill_reference_month,
        bill_value,
        bill_start_date,
        bill_end_date,
        transaction_date,
        transaction_description,
        transaction_value,
        transaction_category,
        'Credit Card Bill' as source_type,
        'BRL' as coin_code,
        case
            when transaction_description like 'Antecipada %'
                then 'Antecipation installment'
            when transaction_description = 'Crédito de atraso'
                then 'Late credit'
            when transaction_description = 'Crédito de parcelamento de compra'
                then 'Installment credit'
            when transaction_description like 'Crédito de "%"'
                then 'Refund'
            when transaction_description like 'Desconto Antecipação %'
                then 'Antecipation discount'
            when transaction_description like 'Estorno de %'
                then 'Refund'
            when transaction_description like 'IOF de %'
                then 'Fee'
            when transaction_description = 'IOF de atraso'
                then 'Late payment fee'
            when transaction_description = 'Juros de atraso'
                then 'Late interest'
            when transaction_description = 'Multa de atraso'
                then 'Late fee'
            when transaction_description like 'Pagamento em %'
                then 'Bill payment'
            when transaction_description like 'Parcelamento de compra %'
                then 'Credit card'
            when transaction_description = 'Saldo em atraso'
                then 'Late balance'
            -- Tem muita informação no Ifood que dá pra extrair
            else 'Credit card' end
            as transaction_type
    from source
)

select
    bank_name,
    source_type,
    bill_date,
    bill_reference_month,
    bill_value,
    bill_start_date,
    bill_end_date,
    transaction_date,
    transaction_type,
    transaction_description,
    coin_code,
    transaction_value,
    transaction_category
from source_with_types
