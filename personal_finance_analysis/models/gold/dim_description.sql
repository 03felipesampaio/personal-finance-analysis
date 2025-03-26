with
sources as (
    select
        description_id,
        description,
        inserted_at,
        updated_at
    from {{ ref('dim_description') }}
)

select distinct * from sources
