with source as (
    select
        type_id,
        type_description,
        type_description_pt,
        inserted_at,
        updated_at
    from {{ ref("type_dimension") }}
)

select * from source
