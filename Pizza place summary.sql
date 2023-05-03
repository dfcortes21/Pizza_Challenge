use PizzaPlace

-- Average Customers per day------------------------------------------------------

select  ceiling(cast(count(order_id) as decimal)/ cast(count(distinct date) as decimal)) as Average_Customers_Per_Day
from Orders

-- Customers per hour-------------------------------------------------------------

select datepart(hour, time) as Hour, count(order_id) as Customers_per_Hour
from Orders
group by datepart(hour, time)
order by Hour 

-- Averrage Pizzas per order ---------------------------------------------------------

SELECT ROUND((SUM(quantity) / COUNT(DISTINCT order_id)), 2) AS Average_Pizzas_Per_Order
FROM OrderDetails;

--Pizzas sold by size-----------------------------------------------------------------

SELECT p.size, COUNT(od.quantity) AS Total_Pizzas_Sold,
	CASE
		WHEN p.size = 'S' THEN 1
		WHEN p.size = 'M' THEN 2
		WHEN p.size = 'L' THEN 3
		WHEN p.size = 'XL' THEN 4
		WHEN p.size = 'XXL' THEN 5
		ELSE 6
	END AS Sort_Column
FROM Pizzas p
JOIN OrderDetails od ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY Sort_Column;
														--case
														--				when p.size = 'S' then 1
														--				when p.size = 'M' then 2
														--				when p.size = 'L' then 3
														--				when p.size = 'XL' then 4
														--				when p.size = 'XLL' then 5
														--				else 6
														--			end;


--Best Sellers -----------------------------------------------------------------------	

select top 5 pt.name, p.size, sum(od.quantity) as total_pizzas_Sold
from Pizzas p 
join PizzaTypes pt on pt.pizza_type_id = p.pizza_type_id
join OrderDetails od on od.pizza_id = p.pizza_id
group by pt.name, p.size
order by total_pizzas_Sold desc

--Worst Sellers -----------------------------------------------------------------------

select top 5 pt.name, p.size, sum(od.quantity) as total_pizzas
from Pizzas p 
join PizzaTypes pt on pt.pizza_type_id = p.pizza_type_id
join OrderDetails od on od.pizza_id = p.pizza_id
group by pt.name, p.size
order by total_pizzas 


--How much money did we make this year?--------------------------------------------------

WITH PizzaRevenue AS (
  SELECT pt.name, SUM(od.quantity) AS total_pizzas, AVG(p.price) AS avg_price, round(SUM(od.quantity),0) * round(AVG(p.price),0) AS revenue
  FROM Pizzas p 
  JOIN PizzaTypes pt ON pt.pizza_type_id = p.pizza_type_id
  JOIN OrderDetails od ON od.pizza_id = p.pizza_id
  GROUP BY pt.name
)
SELECT SUM(revenue) AS total_revenue
FROM PizzaRevenue;


-- Total Revenue by Pizza ---------------------------------------------------------------------

SELECT pt.name, round(avg(p.price),2) as Average_Pizza_Price, sum(od.quantity) as Quantity_Sold, 
(round(avg(p.price),2) *sum(od.quantity))  as Revenue_per_Pizza
FROM Pizzas p
join PizzaTypes pt on pt.pizza_type_id = p.pizza_type_id
join OrderDetails od on od.pizza_id = p.pizza_id
Group by pt.name, od.quantity
order by Revenue_per_Pizza desc

--Revenue per type of pizza -------------------------------------------------------------------

SELECT pt.name, round(avg(p.price),2) as Average_Pizza_Price, sum(od.quantity) as Quantity_Sold
, (round(avg(p.price),2) * (sum(od.quantity)))
FROM Pizzas p
join PizzaTypes pt on pt.pizza_type_id = p.pizza_type_id
join OrderDetails od on od.pizza_id = p.pizza_id
group by pt.name
order by (round(avg(p.price),2) * (sum(od.quantity))) desc
 
-- Sales  by Month ----------------------------------------------------------------------------

SELECT left(DATENAME(month, date),3) AS Months,
       COUNT(order_id) AS Orders
FROM Orders
GROUP BY DATENAME(month, date)
ORDER BY CASE
				WHEN left(DATENAME(month, date),3) = 'Jan' then 1
				WHEN left(DATENAME(month, date),3) = 'FEB' then 2
				WHEN left(DATENAME(month, date),3) = 'MAR' then 3
				WHEN left(DATENAME(month, date),3) = 'APR' then 4
				WHEN left(DATENAME(month, date),3) = 'MAY' then 5
				WHEN left(DATENAME(month, date),3) = 'JUN' then 6
				WHEN left(DATENAME(month, date),3) = 'JUL' then 7
				WHEN left(DATENAME(month, date),3) = 'AUG' then 8
				WHEN left(DATENAME(month, date),3) = 'SEP' then 9
				WHEN left(DATENAME(month, date),3) = 'OCT' then 10
				WHEN left(DATENAME(month, date),3) = 'NOV' then 11
				else 12
			END



									--SELECT left(DATENAME(month, date),3) AS Months,
									--       COUNT(o.order_id) AS Orders, sum(od.quantity) as Total_Quantity_Sold, round(avg(p.price),2) as Avg_Pizza_Price
									--	   , (sum(od.quantity) * round(avg(p.price),2)) as Revenue
									--FROM Orders o
									--join OrderDetails od on od.order_id = o.order_id
									--join Pizzas p on p.pizza_id = od.pizza_id

									--GROUP BY DATENAME(month, date)
									--ORDER BY CASE
									--				WHEN left(DATENAME(month, date),3) = 'Jan' then 1
									--				WHEN left(DATENAME(month, date),3) = 'FEB' then 2
									--				WHEN left(DATENAME(month, date),3) = 'MAR' then 3
									--				WHEN left(DATENAME(month, date),3) = 'APR' then 4
									--				WHEN left(DATENAME(month, date),3) = 'MAY' then 5
									--				WHEN left(DATENAME(month, date),3) = 'JUN' then 6
									--				WHEN left(DATENAME(month, date),3) = 'JUL' then 7
									--				WHEN left(DATENAME(month, date),3) = 'AUG' then 8
									--				WHEN left(DATENAME(month, date),3) = 'SEP' then 9
									--				WHEN left(DATENAME(month, date),3) = 'OCT' then 10
									--				WHEN left(DATENAME(month, date),3) = 'NOV' then 11
									--				else 12
									--			END

--total pizzas ordered -------------------------------------------------------------

select sum(quantity) as Total_Pizzas_Sold
from OrderDetails