{{ config(
    materialized='incremental',
    unique_key='coin_id',
    merge_exclude_columns = ['inserted_at']
) }}

with source as (
    select  
        coin_id,
        coin_code,
        coin_name,
        coin_symbol,
        coin_type,
        thousands_separator,
        decimal_separator,
        current_datetime() AS inserted_at,
        current_datetime() AS updated_at,
    from {{ ref("stg_coins") }}
)
select * from source