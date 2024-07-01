-- Create a temporary table that joins the orders, order_products, and products tables to get information about each order, 
-- including the products that were purchased and their department and aisle information.
-- o.order_id, o.order_number, o.order_dow, o.order_hour_of_day, o.days_since_prior_order, op.product_id, op.add_to_cart_order, op.reordered, p.product_name, p.aisle_id, p.department_id

begin;

create temp table order_details as 
select o.order_id, o.order_number, o.order_dow, o.order_hour_of_day, o.days_since_prior_order, op.product_id, op.add_to_cart_order, op.reordered, p.product_name, p.aisle_id, p.department_id 
from orders o
join order_products op on op.order_id = o.order_id
join products p on p.product_id = op.product_id
;

commit;


--- Create a temporary table that groups the orders by product and finds the total number of times each product was purchased, 
-- the total number of times each product was reordered, and the average number of times each product was added to a cart.

begin;

create temp table product_order_summary  as 
select 
od.product_id,
od.product_name,
count(*) as total_orders,
sum(case when cast(od.reordered as bool) = true then 1 else 0 end) as total_reorders,
avg(od.add_to_cart_order) as avg_add_to_cart
from order_details od
group by od.product_id, od.product_name
;

commit;

--Create a temporary table that groups the orders by department and finds the total number of products purchased, the total number of unique products purchased, 
--  the total number of products purchased on weekdays vs weekends, and the average time of day that products in each department are ordered.

begin;

create temp table department_order_summary as  
select 
od.department_id,  
count(od.product_name) as total_purchases,
count(distinct od.product_name) as total_unique_purchases,
sum(case when od.order_dow between 1 and 5 then 1 else 0 end) as weekday_total_orders,
sum(case when od.order_dow = 0 or od.order_dow = 6 then 1 else 0 end) as weekend_total_orders,
round(avg(order_hour_of_day),2) as avg_order_hr
from order_details od
group by od.department_id
;

commit;

-- Create a temporary table that groups the orders by aisle and finds the top 10 most popular aisles, 
-- including the total number of products purchased and the total number of unique products purchased from each aisle.

begin;

create temp table aisle_order_summary  as  
select 
aisle_id,
count(*) as products_purchased,
count(distinct product_id) as unique_products_purchased
from order_details
group by aisle_id
order by products_purchased desc
limit 10
;

commit;


-- Combine the information from the previous temporary tables into a final table that shows the product ID, product name, 
-- department ID, department name, aisle ID, aisle name, total number of times purchased, 
-- total number of times reordered, average number of times added to cart, total number of products purchased, 
-- total number of unique products purchased, total number of products purchased on weekdays, 
-- total number of products purchased on weekends, and average time of day products are ordered in each department. 

create temp table product_behavior_analysis as
select
pos.product_id, 
pos.product_name, 
p.department_id, 
d.department, 
a.aisle_id, 
a.aisle, 
pos.total_orders, 
pos.total_reorders, 
pos.avg_add_to_cart, 
dos.total_purchases, 
dos.total_unique_purchases, 
dos.weekday_total_orders, 
dos.weekend_total_orders, 
dos.avg_order_hr 
from product_order_summary pos
left join products p on p.product_id = pos.product_id
left join departments d on d.department_id = p.department_id
left join aisles a on a.aisle_id = p.aisle_id
left join department_order_summary dos on dos.department_id = p.department_id
; 



