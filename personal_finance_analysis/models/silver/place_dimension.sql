{{ config(
    materialized='incremental',
    unique_key='place_id',
    merge_exclude_columns = ['inserted_at']
) }}

with source as (
    select 
        place_id,
        place,
        is_online,
        case when category_id is null then -1 else category_id end as category_id,
        current_datetime() AS inserted_at,
        current_datetime() AS updated_at
    from {{ ref("stg_places") }}
    left join {{ ref("stg_categories") }} on stg_places.category = stg_categories.category
)
select * from source