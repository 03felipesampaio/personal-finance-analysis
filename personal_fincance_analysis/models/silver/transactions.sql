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
)
select 
    *,

    CASE 
        WHEN amount < 0 THEN 'Expense'
        ELSE 'Income'
    END as income_or_expense,
    ABS(amount) as amount_abs,
    SUM(amount) OVER (PARTITION BY transaction_date) as daily_balance,
    SUM(amount) OVER (ORDER BY transaction_date RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as daily_cumulative_balance
from stg_transactions
where 1=1
 and transaction_id not in (select transaction_id from refunded_transactions)