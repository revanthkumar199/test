with orders as 
(
select order_id, customer_id, order_date, total_amount, status
from ecom_raw.orders
where order_id is not null
)
select order_id, customer_id, order_date, total_amount, status 
from orders
