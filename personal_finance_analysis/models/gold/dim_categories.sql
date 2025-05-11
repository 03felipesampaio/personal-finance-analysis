with source as (
    select
        category_id,
        category,
        category_pt,
        upper_category,
        upper_category_pt,
        inserted_at,
        updated_at
    from {{ ref('slv_dim_categories') }}
)

select * from source
