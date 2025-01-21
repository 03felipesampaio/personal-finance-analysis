with source as (
    select * from {{ source('bronze', 'statements_inter_regex_mapping') }}
)
select * from source