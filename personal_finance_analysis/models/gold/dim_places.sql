with source as (
    select
        places.place_id,
        places.place,
        places.is_online,
        places.category_id,
        places.inserted_at,
        places.updated_at
    from {{ ref('slv_dim_places') }} as places
)

select * from source
