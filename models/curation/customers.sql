with customers as 
(
select customer_id, name, email, signup_date, country
from ecom_raw.customers
where customer_id is not null
)
select customer_id, name, email, signup_date, country 
from customers
