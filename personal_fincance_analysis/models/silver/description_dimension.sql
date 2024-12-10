-- depends_on: {{ ref('stg_bills__nubank') }}

with bills_nubank as (
    select distinct
        ABS(FARM_FINGERPRINT(transaction_description)) as description_id,
        transaction_description as description
    from {{ ref("stg_bills__nubank") }}
),
all_sources as (
    select * from bills_nubank
    {# Union from here #}
)
select * from all_sources