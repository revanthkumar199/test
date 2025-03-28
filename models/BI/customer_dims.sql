{{ config(
    materialized='incremental'
) }}

WITH new_data AS (
    SELECT
        CUSTOMER_ID,
        NAME,
        EMAIL,
        SIGNUP_DATE,
        COUNTRY
    FROM {{ ref('customers') }}
)

SELECT * FROM new_data

{% if is_incremental() %}
    -- Perform MERGE operation for incremental updates
    MERGE INTO {{ this }} AS target
    USING new_data AS source
    ON target.customer_id = source.customer_id
    WHEN MATCHED THEN
        UPDATE SET
            target.name = source.name,
            target.email = source.email,
            target.signup_date = source.signup_date,
            target.country = source.country
    WHEN NOT MATCHED THEN
        INSERT (customer_id, name, email, signup_date, country)
        VALUES (source.customer_id, source.name, source.email, source.signup_date, source.country)
{% endif %}
