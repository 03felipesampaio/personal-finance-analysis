{{ config(
    materialized='table',
) }}
    {# unique_key='transfer_id',
    merge_exclude_columns = ['inserted_at'] #}

-- FIXME: If we have one row without an input or output, 
-- when a new row is added, it will not be updated
-- We will have two rows with the same transfer_id,
-- one with input and one with output

-- xxxx | 1234 | NULL -> No output

-- A new transaction is addedm so now we have the output
-- But since the first row is not updated,
-- we will have two rows with the same transfer_id

-- xxxx | 1234 | NULL
-- xxxx | NULL | 5678

with
transactions as (
    select
        transaction_id,
        transaction_date,
        coin_code,
        amount
    from {{ ref('stg_transactions_raw') }}
    where transaction_type = 'Transfer between accounts'
),

transfers as (
    select
        outcome.transaction_id as out_transaction_id,
        income.transaction_id as in_transaction_id,
        abs(
            farm_fingerprint(
                concat(
                    coalesce(cast(outcome.transaction_id as string), ''),
                    coalesce(cast(income.transaction_id as string), '')
                )
            )
        ) as transfer_id
    from transactions as income
    full join transactions as outcome
        on
            income.transaction_date = outcome.transaction_date
            and income.amount = outcome.amount * -1
            and income.coin_code = outcome.coin_code
            and income.transaction_id != outcome.transaction_id
    where
        1 = 1
        and (income.amount > 0 or income.amount is null)
        and (outcome.amount < 0 or outcome.amount is null)
)

select
    *,
    current_datetime() as inserted_at,
    current_datetime() as updated_at
from transfers
