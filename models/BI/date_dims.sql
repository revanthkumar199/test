{{ config(
    materialized='incremental',
    unique_key='date_id',
    incremental_strategy='merge',
) }}

WITH new_data AS (
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
        SELECT DISTINCT all_date 
        FROM (
            SELECT order_date AS all_date FROM {{ ref('orders') }}
            UNION
            SELECT signup_date AS all_date FROM {{ ref('customers') }}
        )
    )
)

SELECT * FROM new_data

{% if is_incremental() %}
    -- Perform MERGE operation for incremental updates
    MERGE INTO {{ this }} AS target
    USING new_data AS source
    ON target.date_id = source.date_id
    WHEN MATCHED THEN
        UPDATE SET
            target.date = source.date,
            target.year = source.year,
            target.month = source.month,
            target.day = source.day,
            target.quarter = source.quarter,
            target.week = source.week,
            target.weekday_type = source.weekday_type
    WHEN NOT MATCHED THEN
        INSERT (date_id, date, year, month, day, quarter, week, weekday_type)
        VALUES (source.date_id, source.date, source.year, source.month, source.day, source.quarter, source.week, source.weekday_type)
{% endif %}
