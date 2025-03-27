-- models/date_dim.sql


SELECT
    ROW_NUMBER() OVER (ORDER BY all_date) AS DATE_ID,  -- Generates unique ID for each date
    all_date AS DATE,  -- The actual date
    EXTRACT(YEAR FROM all_date) AS YEAR,  -- Extract year
    EXTRACT(MONTH FROM all_date) AS MONTH,  -- Extract month
    EXTRACT(DAY FROM all_date) AS DAY,  -- Extract day
    EXTRACT(QUARTER FROM all_date) AS QUARTER,  -- Extract quarter
    EXTRACT(WEEK FROM all_date) AS WEEK,  -- Extract week number
    CASE WHEN EXTRACT(DAYOFWEEK FROM all_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS WEEKDAY_TYPE  -- Optional: Extract weekend/weekday
FROM (
SELECT DISTINCT all_date from (
SELECT 
order_date AS all_date
FROM {{ ref('orders') }}  
UNION
SELECT 
signup_date as all_date
FROM {{ ref('customers') }}  
))
