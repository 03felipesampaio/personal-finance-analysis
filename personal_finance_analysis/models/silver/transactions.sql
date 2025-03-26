with
stg_transactions as (
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
    from {{ ref('stg_transactions') }}
),

refunded_transactions as (
    select buy_transaction_id as transaction_id from {{ ref('refunds') }}
    union all
    select refund_transaction_id as transaction_id from {{ ref('refunds') }}
),

bill_payments_transactions as (
    select transaction_id_incomes as transaction_id
    from {{ ref('bill_payments') }}
    union all
    select transaction_id_expenses as transaction_id
    from {{ ref('bill_payments') }}
)

select
    stg_transactions.*,

    case
        when stg_transactions.amount < 0 then 'Expense'
        else 'Income'
    end as income_or_expense,
    ABS(stg_transactions.amount) as amount_abs,
    SUM(stg_transactions.amount)
        over (partition by stg_transactions.transaction_date) as daily_balance,
    SUM(stg_transactions.amount)
        over (
            order by
                stg_transactions.transaction_date
            range between unbounded preceding and current row
        )
        as daily_cumulative_balance
from stg_transactions
left join
    refunded_transactions
    on stg_transactions.transaction_id = refunded_transactions.transaction_id
left join
    bill_payments_transactions
    on
        stg_transactions.transaction_id
        = bill_payments_transactions.transaction_id
where
    1 = 1
    and refunded_transactions.transaction_id is null
    and bill_payments_transactions.transaction_id is null
