with source as (
    select * from {{ ref('statements_inter_regex_mapping') }}
)
select * from source