with source as (
    select * from {{ source('bronze', 'bills_inter_regex_mapping') }}
)
select * from source