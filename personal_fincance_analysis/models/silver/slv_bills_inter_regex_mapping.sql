with source as (
    select 
        regex_id,
        regex_pattern,
        case when place_id is null then -1 else place_id end as place_id,
        transaction_type,
        description,
        active,
        priority
    from {{ ref('stg_bills_inter_regex_mapping') }} as mapping
    left join {{ ref('stg_places') }} as places on mapping.place = places.place
)
select * from source