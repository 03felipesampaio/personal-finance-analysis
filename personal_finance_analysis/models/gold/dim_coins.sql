with source as (
    select
        coin_id,
        coin_code,
        coin_name,
        coin_symbol,
        coin_type,
        thousands_separator,
        decimal_separator,
        inserted_at,
        updated_at
    from {{ ref("slv_dim_coins") }}
)

select * from source
