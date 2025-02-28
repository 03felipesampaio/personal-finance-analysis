{{ config(
    materialized='incremental',
    unique_key='regex_id',
    merge_exclude_columns = ['inserted_at']
) }}

with source as (
    select 
        regex_id,
        regex_pattern,
        case when place_id is null then -1 else place_id end as place_id,
        transaction_type,
        description,
        active,
        priority
    from {{ ref('stg_statements_nubank_regex_mapping') }} as mapping
    left join {{ ref('stg_places') }} as places on mapping.place = places.place
)
select 
    *,
    current_datetime() AS inserted_at,
    current_datetime() AS updated_at,
from source