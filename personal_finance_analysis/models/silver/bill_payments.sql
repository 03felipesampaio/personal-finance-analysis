{{ config(
    materialized='view'
) }}

-- Bill payment logic
with
transactions as (
  select
    t.transaction_id,
    t.transaction_date,
    t.amount
  from {{ ref('stg_transactions') }} as t
  join {{ ref('type_dimension') }} as ty
    on t.type_id = ty.type_id
  where 1=1
    and type_description = 'Bill payment'
),
payments as (
  select
    incomes.transaction_id as transaction_id_incomes,
    expenses.transaction_id  as transaction_id_expenses
  from transactions as incomes
  full join transactions as expenses
    on incomes.transaction_date = expenses.transaction_date
    and incomes.amount = (expenses.amount * -1)
) 
select * from payments
