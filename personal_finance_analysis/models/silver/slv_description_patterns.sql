{{ config(
    materialized='incremental',
    unique_key='regex_id',
    merge_exclude_columns = ['inserted_at']
) }}

with stg as (
    select
        patterns.regex_id,
        patterns.regex_pattern,
        place.place_id,
        patterns.description,
        patterns.priority,

        current_datetime() as inserted_at,
        current_datetime() as updated_at
    from {{ ref('stg_description_patterns') }} as patterns
    inner join {{ ref('place_dimension') }} as place
        on patterns.place = place.place
)

select * from stg
