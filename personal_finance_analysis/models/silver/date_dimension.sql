WITH date_table AS (
  SELECT 
    day AS date_full,
    EXTRACT(YEAR FROM day) AS year,
    EXTRACT(MONTH FROM day) AS month_number,
    FORMAT_TIMESTAMP('%B', TIMESTAMP(day)) AS month,
    EXTRACT(QUARTER FROM day) AS quarter_number,
    CONCAT('Q', EXTRACT(QUARTER FROM day)) AS quarter,
    EXTRACT(DAY FROM day) AS day,
    EXTRACT(DAYOFWEEK FROM day) AS day_of_week_number,
    CASE EXTRACT(DAYOFWEEK FROM day)
      WHEN 1 THEN 'Sunday'
      WHEN 2 THEN 'Monday'
      WHEN 3 THEN 'Tuesday'
      WHEN 4 THEN 'Wednesday'
      WHEN 5 THEN 'Thursday'
      WHEN 6 THEN 'Friday'
      WHEN 7 THEN 'Saturday'
    END AS day_name_en,
    CASE EXTRACT(DAYOFWEEK FROM day)
      WHEN 1 THEN 'Domingo'
      WHEN 2 THEN 'Segunda'
      WHEN 3 THEN 'Terça'
      WHEN 4 THEN 'Quarta'
      WHEN 5 THEN 'Quinta'
      WHEN 6 THEN 'Sexta'
      WHEN 7 THEN 'Sábado'
    END AS day_name_pt,
    EXTRACT(WEEK FROM day) AS week_number,
    CASE 
      WHEN EXTRACT(DAYOFWEEK FROM day) IN (1, 7) THEN TRUE
      ELSE FALSE
    END AS is_weekend
  FROM UNNEST(GENERATE_DATE_ARRAY('2017-01-01', '2040-12-31')) day
)
SELECT
  date_full,
  year,
  quarter,
  month,
  month_number,
  week_number,
  day,
  day_name_en,
  day_name_pt,
  is_weekend,
  -- NULL AS fiscal_year, -- Modify logic for fiscal year as needed
  -- NULL AS fiscal_quarter, -- Modify logic for fiscal quarter as needed
  -- FALSE AS is_holiday, -- Customize logic for holidays
  -- NULL AS holiday_name -- Customize logic for holiday names
FROM date_table