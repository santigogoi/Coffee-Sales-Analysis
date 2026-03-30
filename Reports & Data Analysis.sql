-- Coffee Sales Analysis--
USE coffee_sales_db;

SELECT * FROM city;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;

-- Reports & Data Analysis--
-- 1. Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
SELECT city_name,
       ROUND(population * 0.25/1000000, 2) AS coffee_consumers_million,
       city_rank
FROM city
ORDER BY 2 DESC;

-- 2. Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
SELECT ci.city_name,
       SUM(s.total) AS total_revenue
FROM sales AS s
JOIN customers AS c
ON c.customer_id = s.customer_id
JOIN city AS ci
ON ci.city_id=c.city_id
WHERE EXTRACT(YEAR FROM sale_date) = 2023
AND EXTRACT(QUARTER FROM sale_date) = 4
GROUP BY ci.city_name
ORDER BY 2 DESC;

-- 3. Sales Count for Each Product
-- How many units of each coffee product have been sold?
SELECT p.product_name,
       COUNT(s.sale_id) AS qty_sold
FROM products AS p
JOIN sales AS s
ON p.product_id=s.product_id
GROUP BY 1
ORDER BY 2 DESC;

-- 4.Average Sales Amount per City
-- What is the average sales amount per customer in each city?
SELECT ci.city_name,
       SUM(s.total) AS total_revenue,
       COUNT(DISTINCT s.customer_id) AS total_cx,
	   ROUND(SUM(s.total)/COUNT(DISTINCT s.customer_id), 2) AS average_sales_per_cx
FROM sales AS s
JOIN customers AS c
ON s.customer_id=c.customer_id
JOIN city AS ci
ON c.city_id=ci.city_id
GROUP BY 1
ORDER BY 2 DESC;

-- 5. City Population and Coffee Consumers(25%)
-- Provide a list of cities along with their populations and estimated coffee consumers.
WITH city_table AS
(
SELECT city_name,
       ROUND(population * 0.25/1000000, 2) AS coffee_consumers_millions
FROM city
),
customer_table
AS 
(
SELECT ci.city_name,
       COUNT(DISTINCT c.customer_id) AS unique_cx
FROM sales as s
	JOIN customers as c
	ON c.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1
)
SELECT city_table.city_name,
       city_table.coffee_consumers_millions AS consumers_million,
       customer_table.unique_cx
FROM city_table
JOIN customer_table
ON city_table.city_name=customer_table.city_name;

-- 6. Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?
SELECT * FROM (
    SELECT 
        ci.city_name, 
        p.product_name, 
        COUNT(s.sale_id) AS total_orders,
        DENSE_RANK() OVER (PARTITION BY ci.city_name ORDER BY COUNT(s.sale_id) DESC) AS `rank`
    FROM sales AS s
    JOIN products AS p ON s.product_id = p.product_id
    JOIN customers AS c ON c.customer_id = s.customer_id
    JOIN city AS ci ON ci.city_id = c.city_id
    GROUP BY 1, 2
) AS t1 
WHERE `rank` <= 3;

-- 7. Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?
SELECT ci.city_name, COUNT(DISTINCT s.customer_id) AS unique_customer FROM sales AS s
	JOIN customers AS cu
    ON s.customer_id = cu.customer_id
    JOIN city AS ci
    ON cu.city_id = ci.city_id
GROUP BY 1
ORDER BY 2 DESC;

-- 8. Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer
WITH city_table AS
(
	SELECT ci.city_name,
		   COUNT(DISTINCT s.customer_id) AS total_cx,
		   ROUND(SUM(s.total)/COUNT(DISTINCT s.customer_id), 2) AS avg_sales_per_cx
	FROM sales AS s
	JOIN customers AS c
	ON s.customer_id=c.customer_id
	JOIN city AS ci
	ON c.city_id=ci.city_id
	GROUP BY 1
	ORDER BY 2 DESC
),
city_rent
AS
(
	SELECT city_name,
		   estimated_rent
	FROM city
)
SELECT cr.city_name,
       cr.estimated_rent,
       ct.total_cx,
       ct.avg_sales_per_cx,
       ROUND(cr.estimated_rent/ct.total_cx, 2) AS avg_rent_per_cx
FROM city_rent AS cr
JOIN city_table AS ct ON cr.city_name=ct.city_name
ORDER BY 4 DESC;

-- 9. Average Monthly Sales Growth Per City
-- Sales growth rate: Calculate the average percentage growth (or decline) in monthly sales.
WITH monthly_sales AS (
    SELECT 
        ci.city_name,
        EXTRACT(MONTH FROM sale_date) AS month,
        EXTRACT(YEAR FROM sale_date) AS year,
        SUM(s.total) AS total_sale
    FROM sales AS s
    JOIN customers AS c ON s.customer_id = c.customer_id
    JOIN city AS ci ON ci.city_id = c.city_id
    GROUP BY 1, 2, 3
),
growth_ratio AS (
    SELECT 
        city_name,
        month,
        year,
        total_sale AS cr_month_sale,
        LAG(total_sale, 1) OVER(PARTITION BY city_name ORDER BY year, month) AS last_month_sale
    FROM monthly_sales
)
SELECT 
    city_name,
    ROUND(AVG((cr_month_sale - last_month_sale) / last_month_sale * 100), 2) AS avg_growth_rate
FROM growth_ratio
WHERE last_month_sale IS NOT NULL
GROUP BY city_name
ORDER BY avg_growth_rate ASC;

-- 10. Overall Average Growth
-- Sales growth rate: Calculate the average percentage growth (or decline) in sales over YoY.
WITH yearly_sales AS (
    SELECT 
        ci.city_name,
        EXTRACT(YEAR FROM sale_date) AS year,
        SUM(s.total) AS total_sale
    FROM sales AS s
    JOIN customers AS c ON s.customer_id = c.customer_id
    JOIN city AS ci ON ci.city_id = c.city_id
    GROUP BY 1, 2
),
growth_ratio AS (
    SELECT 
        city_name,
        year,
        total_sale AS cr_year_sale,
        LAG(total_sale, 1) OVER(PARTITION BY city_name ORDER BY year) AS last_year_sale
    FROM yearly_sales
)
SELECT ROUND(AVG(avg_growth_rate), 2) AS overall_avg_decline
FROM (
    SELECT 
        city_name,
        AVG((cr_year_sale - last_year_sale) / last_year_sale * 100) AS avg_growth_rate
    FROM growth_ratio
    WHERE last_year_sale IS NOT NULL
    GROUP BY city_name
) AS city_avg
WHERE avg_growth_rate < 0;

-- 11. Market Potential Analysis
-- Identify the top 3 cities based on the highest sales, return city name, total sales, total rent, total customers, and estimated coffee consumers
WITH city_table
AS
(
	SELECT 
		ci.city_name,
		SUM(s.total) as total_revenue,
		COUNT(DISTINCT s.customer_id) as total_cx,
		ROUND(SUM(s.total)/COUNT(DISTINCT s.customer_id),2) as avg_sale_pr_cx
	FROM sales as s
	JOIN customers as c
	ON s.customer_id = c.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1
	ORDER BY 2 DESC
),
city_rent
AS
(
	SELECT 
		city_name, 
		estimated_rent,
		ROUND((population * 0.25)/1000000, 3) as estimated_coffee_consumer_in_millions
	FROM city
)
SELECT 
	cr.city_name,
	total_revenue,
	cr.estimated_rent as total_rent,
	ct.total_cx,
	estimated_coffee_consumer_in_millions,
	ct.avg_sale_pr_cx,
	ROUND(cr.estimated_rent/ct.total_cx, 2) as avg_rent_per_cx
FROM city_rent as cr
JOIN city_table as ct
ON cr.city_name = ct.city_name
ORDER BY 2 DESC;
