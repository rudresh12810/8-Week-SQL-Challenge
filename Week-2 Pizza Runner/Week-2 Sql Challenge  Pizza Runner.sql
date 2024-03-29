-- CREATE database pizza_runner;
use pizza_runner;

-- -- DROP TABLE IF EXISTS runners;
-- CREATE TABLE runners (
--   runner_id INTEGER,
--   registration_date DATE
-- );
-- INSERT INTO runners
--   (runner_id, registration_date)
-- VALUES
--   (1, '2021-01-01'),
--   (2, '2021-01-03'),
--   (3, '2021-01-08'),
--   (4, '2021-01-15');


-- -- DROP TABLE IF EXISTS customer_orders;
-- CREATE TABLE customer_orders (
--   order_id INTEGER,
--   customer_id INTEGER,
--   pizza_id INTEGER,
--   exclusions VARCHAR(4),
--   extras VARCHAR(4),
--   order_time TIMESTAMP
-- );

-- INSERT INTO customer_orders
--   (order_id, customer_id, pizza_id, exclusions, extras, order_time)
-- VALUES
--   ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
--   ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
--   ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
--   ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
--   ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
--   ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
--   ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
--   ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
--   ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
--   ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
--   ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
--   ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
--   ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
--   ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


-- -- DROP TABLE IF EXISTS runner_orders;
-- CREATE TABLE runner_orders (
--   order_id INTEGER,
--   runner_id INTEGER,
--   pickup_time  VARCHAR(19),
--   distance VARCHAR(7),
--   duration VARCHAR(10),
--   cancellation VARCHAR(23)
-- );

-- INSERT INTO runner_orders
--   (order_id, runner_id, pickup_time, distance, duration, cancellation)
-- VALUES
--   ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
--   ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
--   ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
--   ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
--   ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
--   ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
--   ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
--   ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
--   ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
--   ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


-- -- DROP TABLE IF EXISTS pizza_names;
-- CREATE TABLE pizza_names (
--   pizza_id INTEGER,
--   pizza_name TEXT
-- );
-- INSERT INTO pizza_names
--   (pizza_id, pizza_name)
-- VALUES
--   (1, 'Meatlovers'),
--   (2, 'Vegetarian');


-- -- DROP TABLE IF EXISTS pizza_recipes;
-- CREATE TABLE pizza_recipes (
--   pizza_id INTEGER,
--   toppings TEXT
-- );
-- INSERT INTO pizza_recipes
--   (pizza_id, toppings)
-- VALUES
--   (1, '1, 2, 3, 4, 5, 6, 8, 10'),
--   (2, '4, 6, 7, 9, 11, 12');


-- -- DROP TABLE IF EXISTS pizza_toppings;
-- CREATE TABLE pizza_toppings (
--   topping_id INTEGER,
--   topping_name TEXT
-- );
-- INSERT INTO pizza_toppings
--   (topping_id, topping_name)
-- VALUES
--   (1, 'Bacon'),
--   (2, 'BBQ Sauce'),
--   (3, 'Beef'),
--   (4, 'Cheese'),
--   (5, 'Chicken'),
--   (6, 'Mushrooms'),
--   (7, 'Onions'),
--   (8, 'Pepperoni'),
--   (9, 'Peppers'),
--   (10, 'Salami'),
--   (11, 'Tomatoes'),
--   (12, 'Tomato Sauce');

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 					A. Pizza Metrics
-- 1. How many pizzas were ordered?

use pizza_runner;

select * from customer_orders;
select * from pizza_names;
select * from pizza_recipes;
select * from pizza_toppings;
select * from runner_orders;
select * from runners;


select count(*) Total_orders 
from customer_orders;


-- 2. How many unique customer orders were made?

select count(distinct order_id) 
from customer_orders;



-- 3. How many successful orders were delivered by each runner?

select * from runners;
select * from runner_orders;
select * from customer_orders;

select r.runner_id , count( distinct ro.order_id) as delivered_orders
from runners r
join runner_orders ro on r.runner_id = ro.runner_id
join customer_orders co on ro.order_id = co.order_id
where pickup_time <> 'null'
group by r.runner_id;




-- 4. How many of each type of pizza was delivered?

select  pn.pizza_name, count(co.pizza_id) deliverd_pizzas
from  runner_orders ro  
join customer_orders co on ro.order_id = co.order_id
join pizza_names pn on co.pizza_id = pn.pizza_id
where pickup_time <> 'null'
group by pn.pizza_name;



-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

select * from runner_orders;
select * from customer_orders;
select * from pizza_names;

Select  co. customer_id, pn.pizza_name, count(co.pizza_id) ordered_pizzas
from  runner_orders ro  
join customer_orders co on ro.order_id = co.order_id
join pizza_names pn on co.pizza_id = pn.pizza_id
group by pn.pizza_name, co.customer_id
order by customer_id;

-- OR

Select co.customer_id,
    SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS Meatlovers,
    SUM(CASE WHEN pn.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS Vegetarian
From  runner_orders ro  
Join customer_orders co ON ro.order_id = co.order_id
Join pizza_names pn ON co.pizza_id = pn.pizza_id
Group By co.customer_id
Order By co.customer_id;






-- 6. What was the maximum number of pizzas delivered in a single order?



select co.order_id, count(co.pizza_id) delivered_pizza
from customer_orders co 
join runner_orders ro  on ro.order_id = co.order_id
where pickup_time <> 'null'
group by co.order_id
order by delivered_pizza desc;
 



-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select * from customer_orders;
select * from runner_orders; 

Select co.customer_id, 
Sum(Case 
	When( (exclusions is not null and exclusions <> "null" and length(exclusions ) > 0) 
    or (extras is not null and exclusions <> "null" and  length(extras) >0)	) = True Then 1 Else 0
End) as Changes,

Sum(Case 
	When( (exclusions is not null and exclusions <> "null" and length(exclusions ) > 0) 
    or (extras is not null and exclusions <> "null" and length(extras) >0)	) = True Then 0 Else 1
End) as No_Changes

from customer_orders co
inner join runner_orders ro on co.order_id = ro.order_id
where pickup_time <> "null"
group by co.customer_id;


  


-- 8. How many pizzas were delivered that had both exclusions and extras?

Select co.customer_id, 
Sum(Case 
	When( (exclusions is not null and exclusions <> "null" and length(exclusions ) > 0) 
    And (extras is not null and exclusions <> "null" and  length(extras) >0)	) = True Then 1 Else 0
End) as Changes
from customer_orders co
inner join runner_orders ro on co.order_id = ro.order_id
where pickup_time <> "null"
group by co.customer_id;

-- Or


SELECT 
  customer_id, pizza_id
FROM 
  customer_orders as co 
  INNER JOIN runner_orders as ro on ro.order_id = co.order_id 
WHERE 
  pickup_time<>'null'
  AND (exclusions IS NOT NULL AND exclusions<>'null' AND LENGTH(exclusions)>0) 
  AND (extras IS NOT NULL AND extras<>'null' AND LENGTH(extras)>0); 




-- 9. What was the total volume of pizzas ordered for each hour of the day?

select  hour(order_time) hour, count(pizza_id)
from customer_orders
group by hour(order_time);

-- 10. What was the volume of orders for each day of the week?

select  DAYOFWEEK(order_time) Day, DAYNAME(order_time) DayName, count(pizza_id) Pizzas_Ordered
from customer_orders
group by DAYOFWEEK(order_time), DAYNAME(order_time) ;


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 					B. Runner and Customer Experience
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select * from runners;
select * from customer_orders;

SELECT 
    DATE_FORMAT(DATE_ADD(DATE(registration_date), INTERVAL (4 - DAYOFWEEK(registration_date)) DAY), '%Y-%m-%d') AS week,
    COUNT(runner_id) AS runners
FROM 
    runners
GROUP BY DATE_FORMAT(DATE_ADD(DATE(registration_date), INTERVAL (4 - DAYOFWEEK(registration_date)) DAY), '%Y-%m-%d');


-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

select runner_id, avg(MINUTE(timediff(pickup_time,order_time)) )
from runner_orders ro
join customer_orders co using(order_id)
where pickup_time <> "null"
group by runner_id;


-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

select * from runner_orders;
select * from pizza_toppings;

with cte as(
select co.order_id, count(pizza_id) no_of_pizzas, max(MINUTE(timediff(pickup_time,order_time)))  as prep_time 
from runner_orders ro
join customer_orders co on ro.order_id = co.order_id
where pickup_time <> "null"
group by co.order_id
)
select no_of_pizzas, avg(prep_time)
from cte
group by no_of_pizzas;


-- 4. What was the average distance travelled for each customer?
select customer_id, round(avg(replace(distance, 'km','')),2)
from runner_orders ro
join customer_orders co on ro.order_id = co.order_id
where distance <> "null"
group by customer_id;


-- 5. What was the difference between the longest and shortest delivery times for all orders?

select * from customer_orders;
select * from runner_orders;

select  max(duration)- min(duration) time_diff
from runner_orders
where duration <>  "null" ;




-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

select * from customer_orders;
select * from runner_orders;


select runner_id, order_id, concat(round(AVG(replace(distance, 'km','')  /  duration ),2)," KM") Avg_speed
from runner_orders
where duration <>  "null" 
group by runner_id, order_id;



-- 7. What is the successful delivery percentage for each runner?

select * from customer_orders;
select * from runner_orders;


select runner_id,
	round(sum(case when pickup_time = 'null' then 0 else 1 end) / count(order_id),2) successful_delivery_Percentage
from runner_orders
group by runner_id;



-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 					C. Ingredient Optimisation
-- 1. What are the standard ingredients for each pizza?
 
select *
from Pizza_recipes ;

CREATE table Pizza_recipes_Normalize as (
Select  pizza_id, 
		trim(Substring_index(Substring_index(toppings, ',',n.digit+1), ',', -1)) toppings
From pizza_recipes
Join(Select 0 digit Union All Select 1 Union All Select 2 Union All Select 3 Union All Select 4 Union All Select 5 Union All Select 6 Union All Select 7 Union All Select 8 ) n
	On Length(Replace(toppings, ',', '')) <= Length(toppings) - n.digit
Order by pizza_id, n.digit
);

Select count(prn.pizza_id ) , topping_name
from Pizza_recipes_Normalize prn
join pizza_toppings pt on prn.toppings = pt.topping_id
group by topping_name
having Count(prn.pizza_id) = 2;

-- 2. What was the most commonly added extra?

select * from customer_orders;
With CTE as (
Select  pizza_id, 
		trim(Substring_index(Substring_index(extras, ',',n.digit+1), ',', -1)) extras
From customer_orders
Join(Select 0 digit Union All Select 1 Union All Select 2   ) n
	On Length(Replace(extras, ',', '')) <= Length(extras) - n.digit
where extras <> 'null' and length(extras)>0

-- group by trim(Substring_index(Substring_index(extras, ',',n.digit+1), ',', -1))
-- Order by pizza_id, n.digit
)
select  topping_name, count(pizza_id)
from CTE
join pizza_toppings pt on  pt.topping_id = cte.extras
group by topping_name
limit 1;


-- 3. What was the most common exclusion?

select * from customer_orders;
With CTE as (
select pizza_id, 
		trim(Substring_index(Substring_index(exclusions,',', n.digit+1), ',', -1)) exclusion
from Customer_orders
Join(select 0 digit Union All Select 1 Union All select 2 ) n 
	On Length(Replace(exclusions, ',', '')) <= length(exclusions) - n.digit
where exclusions <> 'null' and length(exclusions) > 0 
)

select topping_name, count(pizza_id)
from CTE
join pizza_toppings pt on pt.topping_id = cte.exclusion
group by pt.topping_name







-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
-- 		- Meat Lovers
-- 		- Meat Lovers - Exclude Beef
-- 		- Meat Lovers - Extra Bacon
-- 		- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers





-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- 		- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"







-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?








-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 					D. Pricing and Ratings
-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
-- 2. What if there was an additional $1 charge for any pizza extras?
-- 		- Add cheese is $1 extra
-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an
--  additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
-- 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- 		- customer_id
-- 		- order_id
-- 		- runner_id
-- 		- rating
-- 		- order_time
-- 		- pickup_time
-- 		- Time between order and pickup
-- 		- Delivery duration
-- 		- Average speed
-- 		- Total number of pizzas
-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre
--  traveled - how much money does Pizza Runner have left over after these deliveries?


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------








