with order_items as 
(
select order_id, product_id, quantity, unit_price
from ecom_raw.order_items
where order_id is not null and product_id is not null
)
select order_id, product_id, quantity, unit_price 
from order_items
