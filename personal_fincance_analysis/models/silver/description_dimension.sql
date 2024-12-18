-- depends_on: {{ ref('stg_bills__nubank') }}

with bills_nubank as (
    select distinct
        ABS(FARM_FINGERPRINT(transaction_description)) as description_id,
        transaction_description as description
    from {{ ref("stg_bills__nubank") }}
),
bills_inter as (
    select distinct
        ABS(FARM_FINGERPRINT(transaction_description)) as description_id,
        transaction_description as description
    from {{ ref("stg_bills_inter") }}
),
all_sources as (
    select * from bills_nubank
    union all
    select * from bills_inter
)
select distinct * from all_sources