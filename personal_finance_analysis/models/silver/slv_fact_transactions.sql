with transactions as (
    select * from {{ ref('stg_transactions_raw') }}
),

patterns as (
    select
        matches.transaction_id,
        patterns.place_id
    from {{ ref('slv_description_matches') }} as matches
    inner join {{ ref('slv_description_patterns') }} as patterns
        on matches.regex_id = patterns.regex_id
),

transactions_with_ids as (
    select
        t.transaction_id,
        t.transaction_date,
        t.source_id,
        coin_dimension.coin_id,
        t.amount,

        coalesce(
            patterns.place_id,
            -- Some transactions do not have a "place",
            -- so we use a "Not apply" value
            -- to indicate that the transaction does not have a place
            if(
                t.transaction_type in (
                    'Transfer sent',
                    'Transfer received',
                    'Withdrawal',
                    'Transfer between accounts',
                    'Bill payment',
                    'Deposit',
                    'Pix sent',
                    'Pix received',
                    'Antecipation installment',
                    'Late credit',
                    'Late balance',
                    'Fee'
                ),
                -2, -- "Not apply" value
                null
            ),
            -1
        ) as place_id,
        coalesce(type_dimension.type_id, -1) as type_id,
        coalesce(
            t.transaction_category,
            place_dimension.category_id,
            -1
        ) as category_id,
        abs(farm_fingerprint(t.transaction_description)) as description_id
    from transactions as t
    left join patterns as patterns
        on patterns.transaction_id = t.transaction_id
    left join {{ ref('slv_dim_coins') }} as coin_dimension
        on t.coin_code = coin_dimension.coin_code
    left join {{ ref('slv_dim_types') }} as type_dimension
        on t.transaction_type = type_dimension.type_description
    left join {{ ref('slv_dim_places') }} as place_dimension
        on patterns.place_id = place_dimension.place_id
    left join {{ ref('slv_dim_categories') }} as category_dimension
        on place_dimension.category_id = category_dimension.category_id
)

select
    transaction_id,
    transaction_date,
    source_id,
    description_id,
    place_id,
    type_id,
    category_id,
    coin_id,
    amount,

    current_datetime() as inserted_at,
    current_datetime() as updated_at
from transactions_with_ids
