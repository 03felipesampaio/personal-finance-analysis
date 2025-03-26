with source as (
    select
        places.place_id,
        places.place,
        places.is_online,
        places.category_id,
        places.inserted_at,
        places.updated_at
    from {{ ref('place_dimension') }} as places
)

select * from source
