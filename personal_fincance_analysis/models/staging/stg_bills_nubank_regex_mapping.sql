with source as (
      select 
        regex_id,
        regex_pattern,
        place,
        transaction_type,
        description,
        active,
        priority
      from {{ source('bronze', 'bills_nubank_regex_mapping') }}
)
select * from source
  