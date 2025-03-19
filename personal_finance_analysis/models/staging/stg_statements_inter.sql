with source as (
    select 
        bank_name,
        'Bank Statement' as source_type,
        statement_account_id,
        statement_start_date,
        statement_end_date,
        transaction_date,
        case
            when transaction_description like 'Aplicação %' then 'Investment'
            when transaction_description like 'CDB %' then 'Investment'
            when transaction_description like 'Inter Conservador Plus FIRF LP' then 'Investment'
            when transaction_description like 'LCI LIQ 90 DIAS BANCO INTER SA' then 'Investment'
            when transaction_description like 'Cashback %' then 'Cashback'
            -- Credito debitado era um serviço do Inter, em que uma compra era feita no crédito, mas o valor era debitado na hora
            when transaction_description like '% crédito debitado %' then 'Debit card'
            when transaction_description like 'Débito Automático Fatura Cartão Inter' then 'Bill payment'
            when transaction_description like 'Pagamento' then 'Bill payment'
            when transaction_description like 'Pagamento Fatura Cartão Inter' then 'Bill payment'
            when transaction_description like 'Pagamento efetuado' then 'Bill payment'
            when transaction_description like 'Pagamento efetuado fatura cartão Inter' then 'Bill payment'
            when transaction_description like 'Pagamento fatura cartão Inter' then 'Bill payment'
            when transaction_description like 'Débito automático -%' then 'Automatic debit'
            when transaction_description like 'Estorno %' then 'Refund'

            -- Tranfers between accounts are stored separately
            when pattern is not null then 'Transfer between accounts'

            when transaction_description like 'Pix enviado: %' then 'Pix sent'
            when transaction_description like 'Cp :%' and transaction_value < 0 then 'Pix sent'
            when transaction_description like 'Pix recebido: %' then 'Pix received'
            when transaction_description like 'Cp :%' and transaction_value >= 0 then 'Pix received'
            else 'Debit card' end
        as transaction_type,
        transaction_description,
        transaction_value,
        transaction_category 
    from {{ source('bronze', 'statements__inter') }}
    left join {{ ref('stg_transfer_between_accounts_patterns') }}
        on regexp_contains(transaction_description, pattern)
)
select * from source