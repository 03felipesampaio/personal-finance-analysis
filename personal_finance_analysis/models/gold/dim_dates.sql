with
source as (
    select
        date_full,
        year_month,
        year,
        year_quarter,
        month,
        month_number,
        week_number,
        day,
        day_name_en,
        day_name_pt,
        is_weekend
    from {{ ref('slv_dim_dates') }}
)

select * from source
