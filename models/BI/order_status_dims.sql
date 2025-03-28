{{ config(
    materialized='incremental'
) }}

WITH new_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY STATUS) AS STATUS_ID,  -- Generates unique ID for each status
        STATUS AS STATUS_DESCRIPTION
    FROM (
        SELECT DISTINCT
            UPPER(STATUS) AS STATUS
        FROM {{ ref('orders') }}
    )
)

SELECT * FROM new_data

{% if is_incremental() %}
    -- Perform MERGE operation for incremental updates
    MERGE INTO {{ this }} AS target
    USING new_data AS source
    ON target.status_id = source.status_id
    WHEN MATCHED THEN
        UPDATE SET
            target.status_description = source.status_description
    WHEN NOT MATCHED THEN
        INSERT (status_id, status_description)
        VALUES (source.status_id, source.status_description)
{% endif %}