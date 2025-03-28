{{ config(
    materialized='incremental'
) }}

WITH new_data AS (
    SELECT
        o.ORDER_ID,
        o.CUSTOMER_ID,
        oi.PRODUCT_ID,
        d.DATE_ID,
        s.STATUS_ID,
        o.TOTAL_AMOUNT,
        COUNT(oi.PRODUCT_ID) AS NUM_ITEMS
    FROM {{ ref('orders') }} o
    JOIN {{ ref('order_items') }} oi ON o.ORDER_ID = oi.ORDER_ID
    JOIN {{ ref('date_dims') }} d ON o.ORDER_DATE = d.DATE
    JOIN {{ ref('order_status_dims') }} s ON UPPER(o.STATUS) = s.STATUS_DESCRIPTION
    GROUP BY o.ORDER_ID, o.CUSTOMER_ID, oi.PRODUCT_ID, d.DATE_ID, s.STATUS_ID, o.TOTAL_AMOUNT
)

SELECT * FROM new_data

{% if is_incremental() %}
    -- Perform MERGE operation for incremental updates
    MERGE INTO {{ this }} AS target
    USING new_data AS source
    ON target.order_id = source.order_id
    WHEN MATCHED THEN
        UPDATE SET
            target.customer_id = source.customer_id,
            target.product_id = source.product_id,
            target.date_id = source.date_id,
            target.status_id = source.status_id,
            target.total_amount = source.total_amount,
            target.num_items = source.num_items
    WHEN NOT MATCHED THEN
        INSERT (order_id, customer_id, product_id, date_id, status_id, total_amount, num_items)
        VALUES (source.order_id, source.customer_id, source.product_id, source.date_id, source.status_id, source.total_amount, source.num_items)
{% endif %}
