with source as (
    select 
        place_id,
        place,
        is_online,
        case when category_id is null then -1 else category_id end as category_id
    from {{ ref("stg_places") }}
    left join {{ ref("stg_categories") }} on stg_places.category = stg_categories.category
)
select * from source