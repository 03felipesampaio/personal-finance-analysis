{{ config(
    materialized='incremental',
    unique_key='place_id',
    merge_exclude_columns = ['inserted_at']
) }}

with source as (
    select
        places.place_id,
        places.place,
        places.is_online,
        coalesce(categories.category_id, -1)
            as category_id,
        current_datetime() as inserted_at,
        current_datetime() as updated_at
    from {{ ref("stg_places") }} as places
    left join
        {{ ref("stg_categories") }} as categories
        on stg_places.category = stg_categories.category
)

select * from source
