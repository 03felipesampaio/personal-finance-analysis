with source as (
    select
        category_id,
        category,
        category_pt,
        upper_category,
        upper_category_pt,
        inserted_at,
        updated_at
    from {{ ref('category_dimension') }}
)

select * from source
