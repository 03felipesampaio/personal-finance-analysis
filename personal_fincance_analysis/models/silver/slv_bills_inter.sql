with source as (
    select * from {{ ref("stg_bills_inter") }}
)
select * from source