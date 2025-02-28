with source as (
    select * from {{ ref('bills_inter_regex_mapping') }}
)
select * from source