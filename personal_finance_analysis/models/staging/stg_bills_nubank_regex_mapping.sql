with source as (
      select 
        regex_id,
        regex_pattern,
        place,
        transaction_type,
        description,
        active,
        priority
      from {{ ref('bills_nubank_regex_mapping') }}
)
select * from source
  