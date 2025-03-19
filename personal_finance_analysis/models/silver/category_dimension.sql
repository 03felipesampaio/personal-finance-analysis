{{
  config(
    materialized = 'incremental',
    unique_key = 'category_id',
    merge_exclude_columns = ['inserted_at']
    )
}}

with source as (
    select 
        category_id,
        category,
        category_pt,
        upper_category,
        upper_category_pt,
        current_datetime() AS inserted_at,
        current_datetime() AS updated_at
    from {{ ref("stg_categories") }}
)
select * from source