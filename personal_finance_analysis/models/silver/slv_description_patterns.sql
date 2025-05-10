{{ config(
    materialized='incremental',
    unique_key='regex_id',
    merge_exclude_columns = ['inserted_at']
) }}

with stg as (
    select
        patterns.regex_id,
        patterns.regex_pattern,
        patterns.description,
        patterns.priority,
        coalesce(place.place_id, -1) as place_id,

        current_datetime() as inserted_at,
        current_datetime() as updated_at
    from {{ ref('stg_description_patterns') }} as patterns
    left join {{ ref('slv_dim_places') }} as place
        on patterns.place = place.place
)

select * from stg
