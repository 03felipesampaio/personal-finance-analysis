{{
    config(
    materialized = 'view',
    schema = 'expenses_tracker_gold'
    )
}}

with transactions_with_ids as (
    select 
        *
    from {{ ref("transactions") }}
),
transactions as (
    select
        transaction_id,
        transaction_date,
        
        source_dimension.bank_name,
        source_dimension.source_type,

        description_dimension.description,

        place_dimension.place,

        type_dimension.type_description,

        category_dimension.category,
        category_dimension.upper_category,

        coin_dimension.coin_symbol,

        amount

    from transactions_with_ids
    join {{ ref("source_dimension") }} on source_dimension.source_id = transactions_with_ids.source_id
    join {{ ref("description_dimension") }} on description_dimension.description_id = transactions_with_ids.description_id
    join {{ ref("place_dimension") }} on place_dimension.place_id = transactions_with_ids.place_id
    join {{ ref("type_dimension") }} on type_dimension.type_id = transactions_with_ids.type_id
    join {{ ref("category_dimension") }} on category_dimension.category_id = transactions_with_ids.category_id
    join {{ ref("coin_dimension") }} on coin_dimension.coin_id = transactions_with_ids.coin_id
)
select * from transactions