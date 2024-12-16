with source as (
    select * from {{ ref("slv_bills_inter") }}
)
select * from source