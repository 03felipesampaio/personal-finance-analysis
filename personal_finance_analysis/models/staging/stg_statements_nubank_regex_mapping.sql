with source as (
    select * from {{ ref('statements_nubank_regex_mapping') }}
)
select * from source