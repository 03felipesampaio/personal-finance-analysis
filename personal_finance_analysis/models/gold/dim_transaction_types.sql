with source as (
    select
        type_id,
        type_description,
        type_description_pt,
        inserted_at,
        updated_at
    from {{ ref("slv_dim_types") }}
)

select * from source
