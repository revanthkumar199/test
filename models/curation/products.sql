with products as 
(
select product_id, name, category, price, in_stock
from ecom_raw.products
where product_id is not null
)
select product_id, name, category, price, in_stock 
from products
