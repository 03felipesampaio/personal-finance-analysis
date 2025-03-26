with source as (
    select
        transaction_description as description,
        ABS(FARM_FINGERPRINT(transaction_description)) as description_id
    from {{ ref("stg_transactions") }}
)

select distinct
    description_id,
    description
from source
