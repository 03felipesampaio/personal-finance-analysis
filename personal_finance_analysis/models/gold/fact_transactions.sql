with
transactions as (
    select
        transaction_id,
        transaction_date,
        source_id,
        description_id,
        place_id,
        type_id,
        category_id,
        coin_id,
        amount
        {# income_or_expense,
        amount_abs,
        daily_cumulative_balance #}
    from {{ ref('slv_fact_transactions') }}
),

duplicated_transactions as (
    select in_transaction_id as transaction_id
    from {{ ref('transfers_between_accounts') }}

    union all

    select out_transaction_id
    from {{ ref('transfers_between_accounts') }}

    union all

    select transaction_id_incomes
    from {{ ref('bill_payments') }}

    union all

    select transaction_id_expenses
    from {{ ref('bill_payments') }}
)

select transactions.*
from transactions
left join duplicated_transactions
    on transactions.transaction_id = duplicated_transactions.transaction_id
where duplicated_transactions.transaction_id is null
