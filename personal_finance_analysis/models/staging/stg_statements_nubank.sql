with source as (
    select
        statements.bank_name,
        'Bank Statement' as source_type,
        statements.statement_account_id,
        statements.statement_start_date,
        statements.statement_end_date,
        statements.transaction_date,
        statements.transaction_description,
        'BRL' as coin_code,
        statements.transaction_value,
        statements.transaction_category,
        case
            when statements.transaction_description like 'Cashback %' then 'Cashback'
            when
                statements.transaction_description = 'Depósito Recebido por Boleto'
                then 'Deposit'
            when statements.transaction_description like 'Estorno %' then 'Refund'
            when
                statements.transaction_description like 'Reembolso recebido pelo Pix %'
                then 'Refund'
            when
                statements.transaction_description like 'Débito automático -%'
                then 'Automatic debit'
            when
                statements.transaction_description = 'Pagamento da fatura - Cartão Nubank'
                then 'Bill payment'
            when
                statements.transaction_description = 'Pagamento de fatura'
                then 'Bill payment'
            when
                statements.transaction_description like 'Pagamento de boleto efetuado %'
                then 'Payment slip'

            -- Tranfers between accounts are stored separately
            when pattern is not null then 'Transfer between accounts'

            when
                statements.transaction_description like 'Transferência Recebida - %'
                then 'Transfer received'
            when
                statements.transaction_description like 'Transferência enviada - %'
                then 'Tranfer sent'
            when
                statements.transaction_description like 'Transferência enviada pelo Pix - %'
                then 'Pix sent'
            when
                statements.transaction_description like 'Transferência recebida pelo Pix - %'
                then 'Pix received'
            else 'Debit card' end
            as transaction_type
    from {{ source('bronze', 'statements__nubank') }} as statements
    left join {{ ref('stg_transfer_between_accounts_patterns') }} as p
        on regexp_contains(statements.transaction_description, p.pattern)
)

select * from source
