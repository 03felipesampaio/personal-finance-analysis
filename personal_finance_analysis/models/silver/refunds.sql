with
transactions as (
  select
    t.source_id,
    s.bank_name,
    s.source_type,
    ty.type_description,
    t.transaction_id,
    t.transaction_date,
    t.place_id,
    t.amount,

  from {{ ref('stg_transactions') }} as t
  join {{ ref('source_dimension') }} as s
    on s.source_id = t.source_id
  join {{ ref('type_dimension') }} as ty
    on t.type_id = ty.type_id
),
buy_and_refund as (
  select
    buy.transaction_id as buy_transaction_id,
    refund.transaction_id as refund_transaction_id

  from transactions as buy
  right join transactions as refund
    on buy.place_id = refund.place_id
      and buy.amount = refund.amount * -1
      and buy.transaction_date <= refund.transaction_date
      and buy.bank_name = refund.bank_name
      and buy.source_type = refund.source_type
  where refund.type_description = 'Refund'

)
select * from buy_and_refund