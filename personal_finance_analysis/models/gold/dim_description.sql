with
sources as (
    select
        description_id,
        description,
        inserted_at,
        updated_at
    from {{ ref('description_dimension') }}
)

select distinct * from sources
