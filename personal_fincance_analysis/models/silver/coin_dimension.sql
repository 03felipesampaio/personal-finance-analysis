with source as (
    select  * from {{ ref("stg_coins") }}
)
select * from source