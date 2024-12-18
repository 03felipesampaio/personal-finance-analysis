with source as (
    select 
        bank_name,
        'Bank Statement' as source_type,
        statement_account_id,
        statement_start_date,
        statement_end_date,
        transaction_date,
        case
            when transaction_description like 'Cashback %' then 'Cashback'
            when transaction_description = 'Depósito Recebido por Boleto' then 'Deposit'
            when transaction_description like 'Estorno %' then 'Refund'
            when transaction_description like 'Reembolso recebido pelo Pix %' then 'Refund'
            when transaction_description like 'Débito automático -%' then 'Automatic debit'
            when transaction_description = 'Pagamento da fatura - Cartão Nubank' then 'Bill payment'
            when transaction_description = 'Pagamento de fatura' then 'Bill payment'
            when transaction_description like 'Pagamento de boleto efetuado %' then 'Payment slip'
            when transaction_description like 'Transferência Recebida - %' then 'Transfer received'
            when transaction_description like 'Transferência enviada - %' then 'Tranfer sent'
            when transaction_description like 'Transferência enviada pelo Pix - %' then 'Pix sent'
            when transaction_description like 'Transferência recebida pelo Pix - %' then 'Pix received'
            else 'Debit card' end
        as transaction_type,
        transaction_description,
        transaction_value,
        transaction_category 
    from {{ source('bronze', 'statements__nubank') }}
)
select * from source