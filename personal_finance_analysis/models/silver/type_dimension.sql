{{ config(
    materialized='incremental',
    unique_key='type_id',
    merge_exclude_columns = ['inserted_at']
) }}

with source as (
    select
        type_id,
        type_description,
        type_description_pt,
        current_datetime() as inserted_at,
        current_datetime() as updated_at
    from {{ ref("stg_transaction_types") }}
)

select * from source
