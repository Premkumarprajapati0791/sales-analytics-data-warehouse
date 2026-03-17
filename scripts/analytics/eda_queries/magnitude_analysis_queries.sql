-- magnitude analysis

-- find the total num of customer by country
SELECT country, COUNT(customer_id) as cust_cntry
FROM gold.dim_customers
GROUP BY country
ORDER BY cust_cntry DESC;

-- total customer by gender 
SELECT gender, COUNT(customer_id) as cust_gender
FROM gold.dim_customers
GROUP BY gender
ORDER BY cust_gender DESC;

-- total product by category
SELECT category, COUNT(product_id) as pro_cat
FROM gold.dim_products
GROUP BY category
ORDER BY pro_cat DESC;

-- what is the avg cost in each category
SELECT category, AVG(cost) as avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- total revenue genrated for each category
SELECT pd.category AS category,
	   sum(quantity*price) as total
FROM gold.fact_sales as fs
LEFT JOIN gold.dim_products as pd
ON pd.product_key = fs.product_key
GROUP BY category
ORDER BY total DESC;

-- total revenue by each customer
SELECT 
	   concat(first_name,' ',last_name) as full_name,
	   sum(quantity*price) as total
FROM gold.fact_sales as fs
LEFT JOIN  gold.dim_customers as c
ON fs.customer_key = c.customer_key
GROUP BY full_name
ORDER BY total DESC;

-- what is the distribution of item sold across countries
SELECT 
	   c.country as country,
	   count(fs.order_number) as Total_orders,
       ROUND(count(fs.order_number)*100 / (SELECT COUNT(*) FROM  gold.fact_sales),2) AS PER,
       sum(quantity*price) as total,
       ROUND(sum(quantity*price) *100 / (SELECT sum(quantity*price)  FROM  gold.fact_sales),2) AS PER_REV
FROM gold.fact_sales as fs
LEFT JOIN  gold.dim_customers as c
ON fs.customer_key = c.customer_key
GROUP BY country
ORDER BY Total_orders desc;

