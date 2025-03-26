with bills_nubank as (
    select distinct
        ABS(FARM_FINGERPRINT(transaction_description)) as description_id,
        transaction_description as description
    from {{ ref("slv_bills_nubank") }}
),

bills_inter as (
    select distinct
        ABS(FARM_FINGERPRINT(transaction_description)) as description_id,
        transaction_description as description
    from {{ ref("slv_bills_inter") }}
),

statements_nubank as (
    select distinct
        ABS(FARM_FINGERPRINT(transaction_description)) as description_id,
        transaction_description as description
    from {{ ref("slv_statements_nubank") }}
),

statements_inter as (
    select distinct
        ABS(FARM_FINGERPRINT(transaction_description)) as description_id,
        transaction_description as description
    from {{ ref("slv_statements_inter") }}
),

all_sources as (
    select * from bills_nubank
    union all
    select * from bills_inter
    union all
    select * from statements_nubank
    union all
    select * from statements_inter
)

select distinct * from all_sources
