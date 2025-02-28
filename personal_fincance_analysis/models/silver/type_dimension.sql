{{ config(
    materialized='incremental',
    unique_key='type_id',
    merge_exclude_columns = ['inserted_at']
) }}

with source as (
    select 
        *,
        current_datetime() AS inserted_at,
        current_datetime() AS updated_at,
    from {{ ref("stg_transaction_types") }}
)
select * from source