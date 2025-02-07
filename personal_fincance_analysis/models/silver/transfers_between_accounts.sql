with
transactions as (
    select
        transaction_id,
        transaction_date,
        coin_id,
        amount
    from {{ ref('stg_transactions') }}
    join {{ ref('transaction_types') }}
        on stg_transactions.type_id = transaction_types.type_id
    where transaction_types.type_description = 'Transfer between accounts'
),
transfers as (
    select
        abs(farm_fingerprint(concat(coalesce(cast(out.transaction_id as string), ''), coalesce(cast(inc.transaction_id as string), '')))) as transfer_id,
        out.transaction_id as out_transaction_id,
        inc.transaction_id as in_transaction_id,
    from transactions as inc
    full join transactions as out
        on inc.transaction_date = out.transaction_date
        and inc.amount = out.amount * -1
        and inc.coin_id = out.coin_id
        and inc.transaction_id != out.transaction_id
    where 1=1
        and (inc.amount > 0 or inc.amount is null)
        and (out.amount < 0 or out.amount is null)
)
select
    *
from transfers