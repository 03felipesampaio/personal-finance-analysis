{{ config(
    materialized='table'
) }}

with bills_nubank as (
  select 
    bank_name,
    source_type,
    bill_start_date as source_start,
    bill_end_date as source_end,

    bill.transaction_type,

    transaction_date,
    transaction_description,
    transaction_category,
    transaction_value * -1 as amount,

    coalesce(mapping_nubank_regex_bills.place_id, -1) as place_id,


  from {{ ref('stg_bills__nubank') }} as bill
  left join {{ ref('slv_bills_nubank_regex_mapping') }} as mapping_nubank_regex_bills
    on regexp_contains(transaction_description, regex_pattern)
      and mapping_nubank_regex_bills.active = true
),
bills_inter as (
  select 
    bank_name,
    source_type,
    bill_start_date as source_start,
    bill_end_date as source_end,

    bill.transaction_type,

    transaction_date,
    transaction_description,
    transaction_category,
    transaction_value * -1 as amount,

    coalesce(mapping_inter_regex_bills.place_id, -1) as place_id,


  from {{ ref('stg_bills_inter') }} as bill
  left join {{ ref('slv_bills_inter_regex_mapping') }} as mapping_inter_regex_bills
    on regexp_contains(transaction_description, regex_pattern)
      and mapping_inter_regex_bills.active = true
),
statements_nubank as (
  select 
    bank_name,
    source_type,
    statement_start_date as source_start,
    statement_end_date as source_end,

    statement.transaction_type,

    transaction_date,
    transaction_description,
    transaction_category,
    transaction_value as amount,

    coalesce(mapping_nubank_regex_statement.place_id, -1) as place_id,


  from {{ ref('stg_statements_nubank') }} as statement
  left join {{ ref('slv_statements_nubank_regex_mapping') }} as mapping_nubank_regex_statement
    on regexp_contains(transaction_description, regex_pattern)
      and mapping_nubank_regex_statement.active = true
),
statements_inter as (
  select 
    bank_name,
    source_type,
    statement_start_date as source_start,
    statement_end_date as source_end,

    statement.transaction_type,

    transaction_date,
    transaction_description,
    transaction_category,
    transaction_value as amount,

    coalesce(mapping_inter_regex_statement.place_id, -1) as place_id,


  from {{ ref('stg_statements_inter') }} as statement
  left join {{ ref('slv_statements_inter_regex_mapping') }} as mapping_inter_regex_statement
    on regexp_contains(transaction_description, regex_pattern)
      and mapping_inter_regex_statement.active = true
),
transactions_without_dimensions_and_fact_ids as (
  select * from bills_nubank
  union all
  select * from bills_inter
  union all
  select * from statements_inter
  union all
  select * from statements_nubank
),
transactions_without_fact_ids as (
  select
    abs(farm_fingerprint(CONCAT(bank_name, source_type, source_start, source_end))) AS source_id,
    coalesce(type_dimension.type_id, -1) as type_id,
    abs(farm_fingerprint(transaction_description)) description_id,
    transactions_without_dimensions_and_fact_ids.place_id,
    coalesce(transaction_category, place_dimension.category_id, -1) as category_id,
    transaction_date,
    coin_id,
    amount

    from transactions_without_dimensions_and_fact_ids
    left join {{ ref('type_dimension') }} as type_dimension
        on transactions_without_dimensions_and_fact_ids.transaction_type = type_dimension.type_description
    left join {{ ref('place_dimension') }} as place_dimension
        on place_dimension.place_id = transactions_without_dimensions_and_fact_ids.place_id
    join {{ ref('coin_dimension') }} as coin_dimension on coin_dimension.coin_code = 'BRL'
),
transactions as (
  select
    {{ generate_transaction_id('transaction_date', 'source_id', 'description_id', 'amount') }} as transaction_id,
    *
  from transactions_without_fact_ids
)
select * from transactions