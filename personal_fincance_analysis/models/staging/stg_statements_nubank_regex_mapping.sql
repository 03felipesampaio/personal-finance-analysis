with source as (
    select * from {{ source('bronze', 'statements_nubank_regex_mapping') }}
)
select * from source