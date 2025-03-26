with
source as (
    select
        date_full,
        year,
        quarter,
        month,
        month_number,
        week_number,
        day,
        day_name_en,
        day_name_pt,
        is_weekend
    from {{ ref('date_dimension') }}
)

select * from source
