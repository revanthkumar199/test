-- models/order_status_dim.sql

SELECT
    ROW_NUMBER() OVER (ORDER BY STATUS) AS STATUS_ID,
    STATUS AS STATUS_DESCRIPTION
FROM  (   
SELECT DISTINCT
    UPPER(STATUS) AS STATUS
FROM {{ ref('orders') }}
)