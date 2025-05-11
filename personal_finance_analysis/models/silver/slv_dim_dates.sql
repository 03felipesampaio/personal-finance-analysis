WITH date_table AS (
    SELECT
        dt AS date_full,
        FORMAT_DATE('%Y-%m', dt) AS year_month,
        EXTRACT(YEAR FROM dt) AS year,
        EXTRACT(MONTH FROM dt) AS month_number,
        FORMAT_TIMESTAMP('%B', TIMESTAMP(dt)) AS month,
        EXTRACT(QUARTER FROM dt) AS quarter_number,
        CONCAT('Q', EXTRACT(QUARTER FROM dt)) AS year_quarter,
        EXTRACT(DAY FROM dt) AS day,
        EXTRACT(DAYOFWEEK FROM dt) AS day_of_week_number,
        CASE EXTRACT(DAYOFWEEK FROM dt)
            WHEN 1 THEN 'Sunday'
            WHEN 2 THEN 'Monday'
            WHEN 3 THEN 'Tuesday'
            WHEN 4 THEN 'Wednesday'
            WHEN 5 THEN 'Thursday'
            WHEN 6 THEN 'Friday'
            WHEN 7 THEN 'Saturday'
        END AS day_name_en,
        CASE EXTRACT(DAYOFWEEK FROM dt)
            WHEN 1 THEN 'Domingo'
            WHEN 2 THEN 'Segunda'
            WHEN 3 THEN 'Terça'
            WHEN 4 THEN 'Quarta'
            WHEN 5 THEN 'Quinta'
            WHEN 6 THEN 'Sexta'
            WHEN 7 THEN 'Sábado'
        END AS day_name_pt,
        EXTRACT(WEEK FROM dt) AS week_number,
        COALESCE(EXTRACT(DAYOFWEEK FROM dt) IN (1, 7), FALSE) AS is_weekend
    FROM UNNEST(GENERATE_DATE_ARRAY('2017-01-01', '2040-12-31')) AS dt
)

SELECT
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
-- NULL AS fiscal_year, -- Modify logic for fiscal year as needed
-- NULL AS fiscal_quarter, -- Modify logic for fiscal quarter as needed
-- FALSE AS is_holiday, -- Customize logic for holidays
-- NULL AS holiday_name -- Customize logic for holiday names
FROM date_table
