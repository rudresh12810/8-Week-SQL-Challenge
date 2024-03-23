-- CREATE Database dannys_diner;
-- use dannys_diner;

-- CREATE TABLE sales (
--   customer_id VARCHAR(1),
--   order_date DATE,
--   product_id INTEGER
-- );

-- INSERT INTO sales
--   (customer_id, order_date, product_id)
-- VALUES
--   ('A', '2021-01-01', '1'),
--   ('A', '2021-01-01', '2'),
--   ('A', '2021-01-07', '2'),
--   ('A', '2021-01-10', '3'),
--   ('A', '2021-01-11', '3'),
--   ('A', '2021-01-11', '3'),
--   ('B', '2021-01-01', '2'),
--   ('B', '2021-01-02', '2'),
--   ('B', '2021-01-04', '1'),
--   ('B', '2021-01-11', '1'),
--   ('B', '2021-01-16', '3'),
--   ('B', '2021-02-01', '3'),
--   ('C', '2021-01-01', '3'),
--   ('C', '2021-01-01', '3'),
--   ('C', '2021-01-07', '3');
--  

-- CREATE TABLE menu (
--   product_id INTEGER,
--   product_name VARCHAR(5),
--   price INTEGER
-- );

-- INSERT INTO menu
--   (product_id, product_name, price)
-- VALUES
--   ('1', 'sushi', 10),
--   ('2', 'curry', 15),
--   ('3', 'ramen', 12);
--   

-- CREATE TABLE members (
--   customer_id VARCHAR(1),
--   join_date DATE
-- );

-- INSERT INTO members
--   (customer_id, join_date)
-- VALUES
--   ('A', '2021-01-07'),
--   ('B', '2021-01-09');
  
  
  --------------------------------------------------------------------------------------------------------------- 
  
  /* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

--------------------------------------------------------------------------------------------------------------------------------------
use dannys_diner;
-- 1. What is the total amount each customer spent at the restaurant?

use dannys_diner;

select * from members;
select * from menu;
select * from sales;

-- select * from members m
-- inner join sales s on m.customer_id = s.customer_id
-- inner join menu on s.product_id = menu.product_id;

select customer_id, sum(price) from members m
inner join sales s using(customer_id)
inner join menu  using (product_id)
group by customer_id;



-- 2. How many days has each customer visited the restaurant?

select * from members;
select * from menu;
select * from sales;

select order_date, count(customer_id) Total_customer from members m
inner join sales s using(customer_id)
group by order_date 
order by order_date asc;


-- 3. What was the first item from the menu purchased by each customer?

with cte as (
	select customer_id,product_name,order_date, 
	rank () over(partition by customer_id order by order_date asc) ranks,
	row_number() over(partition by  customer_id order by order_date asc) rownumber,
	dense_rank() over(partition by customer_id order by order_date asc) denserank
	from members m
	inner join sales s using(customer_id)
	inner join menu  using (product_id) )
    
select customer_id, product_name from cte 
where ranks = 1;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select * from menu;
select * from members; 
select * from sales;

select  product_name, count(order_date)
from sales s
inner join menu  using (product_id) 
group by product_name;


-- 5. Which item was the most popular for each customer?

-- select  product_name, customer_id,count(customer_id) popular
-- from sales 
-- join menu using(product_id)
-- group by  product_name, customer_id
-- order by popular desc;


select  product_name, customer_id,count(order_date) Orders
from sales 
join menu using(product_id)
group by  product_name, customer_id;



-- 6. Which item was purchased first by the customer after they became a member?


select * from menu;
select * from members; 
select * from sales;


with CTE as(
select *, 
		-- rank() over(partition by customer_id order by order_date ) rnk,
		row_number() over(partition by customer_id order by order_date ) rown
from members 
join sales using (customer_id)
join menu using (product_id)
where join_date <= order_date
)
select * 
from CTE 
where rown = 1;



-- 7. Which item was purchased just before the customer became a member?

with CTE as (
select * ,
		rank() over(partition by customer_id order by order_date desc) rnk
from members
join sales using (customer_id)
join menu using (product_id)
where join_date >= order_date
)

select * 
from CTE
where rnk =1;


-- 8. What is the total items and amount spent for each member before they became a member?

select  customer_id, count(product_id) total_item, sum(price) Total_spent
from members 
join sales using (customer_id)
join menu using(product_id)
where order_date < join_date
group by customer_id
order by customer_id;


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?


select Customer_id,
sum(case
	when product_name = 'sushi' then price * 10 *2 
    else price * 10
end ) Points
from menu
join sales using(product_id)
group by customer_id;


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

Select customer_id, 
Sum(Case 
		When order_date between join_date and DATE_ADD(join_date, INTERVAL 6 DAY) then price * 10 * 2 
		When product_name = 'sushi' then price * 10 * 2
		Else price * 10 
	End
    ) Points
From menu m
inner join sales s using(product_id)
inner join members mem using(customer_id)
where order_Date >= join_date and month(order_date) = 1
group by customer_id

























