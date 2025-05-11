with
sources as (
    select
        description_id,
        description,
        inserted_at,
        updated_at
    from {{ ref('slv_dim_descriptions') }}
)

select distinct * from sources
