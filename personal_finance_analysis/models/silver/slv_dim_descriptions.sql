{{
  config(
    materialized = 'incremental',
    unique_key = 'description_id',
    merge_exclude_columns = ['inserted_at']
    )
}}

with source as (
    select distinct
        transaction_description as description,
        ABS(FARM_FINGERPRINT(transaction_description)) as description_id
    from {{ ref("stg_transactions") }}
)

select
    description_id,
    description,
    CURRENT_DATETIME() as inserted_at,
    CURRENT_DATETIME() as updated_at
from source
