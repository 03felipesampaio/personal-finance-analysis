with nubank_bills as (
    select 
        transaction_date,
        source_id,
        description_id,
        place_id,
        type_id,
        category_id,
        coin_id,
        transaction_value * -1 as amount -- Since it's a bill, the value is negative
    from {{ ref("slv_bills_nubank") }}
),
bills_inter as (
    select 
        transaction_date,
        source_id,
        description_id,
        place_id,
        type_id,
        category_id,
        coin_id,
        transaction_value * -1 as amount -- Since it's a bill, the value is negative
    from {{ ref("slv_bills_inter") }}
),
statements_nubank as (
    select 
        transaction_date,
        source_id,
        description_id,
        place_id,
        type_id,
        category_id,
        coin_id,
        transaction_value
    from {{ ref("slv_statements_nubank") }}
),
statements_inter as (
    select 
        transaction_date,
        source_id,
        description_id,
        place_id,
        type_id,
        category_id,
        coin_id,
        transaction_value
    from {{ ref("slv_statements_inter") }}
),
all_sources as (
    select * from nubank_bills
    union all
    select * from bills_inter
    union all
    select * from statements_nubank
    union all
    select * from statements_inter
    -- Union from here
)
select 
    -- Essa chave aqui ta errada, exitem compras feitas no mesmo dia, no mesmo lugar e no mesmo valor
    ABS(FARM_FINGERPRINT(CONCAT(transaction_date, source_id, description_id, amount))) as transaction_id,
    * 
from all_sources