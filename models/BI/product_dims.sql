{{ config(
    materialized='incremental'
) }}

WITH new_data AS (
    SELECT
        PRODUCT_ID,
        NAME,
        CATEGORY,
        PRICE,
        IN_STOCK
    FROM {{ ref('products') }}
)

SELECT * FROM new_data

{% if is_incremental() %}
    -- Perform MERGE operation for incremental updates
    MERGE INTO {{ this }} AS target
    USING new_data AS source
    ON target.product_id = source.product_id
    WHEN MATCHED THEN
        UPDATE SET
            target.name = source.name,
            target.category = source.category,
            target.price = source.price,
            target.in_stock = source.in_stock
    WHEN NOT MATCHED THEN
        INSERT (product_id, name, category, price, in_stock)
        VALUES (source.product_id, source.name, source.category, source.price, source.in_stock)
{% endif %}
