with
source as (
    select
        transaction_id,
        transaction_date,
        source_id,
        description_id,
        place_id,
        type_id,
        category_id,
        coin_id,
        amount
        {# income_or_expense,
        amount_abs,
        daily_cumulative_balance #}
    from {{ ref('slv_fact_transactions') }}
)

select * from source
