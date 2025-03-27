-- models/product_dim.sql


SELECT
PRODUCT_ID,
NAME,
CATEGORY,
PRICE,
IN_STOCK
FROM {{ ref('products') }}