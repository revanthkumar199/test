-- models/order_facts.sql

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
