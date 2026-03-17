-- base query : Retrive core coulmn from tables 

CREATE VIEW gold.report_customers AS
WITH base_query AS(
-- base query : Retrive core coulmn from tables 
SELECT 
		f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        concat(c.first_name, ' ' , c.last_name) as customer_name,
        TIMESTAMPDIFF(YEAR, c.birthday, CURDATE()) AS age
FROM gold_dim_customers as c
INNER JOIN gold.fact_sales as f
ON c.customer_key = f.customer_key
WHERE f.order_date IS NOT NULL)

, customer_aggeration AS
--  Aggregates customer-level metrics 
(SELECT 
	  customer_key,
      customer_number,
      customer_name,
      age,
      COUNT(DISTINCT order_number) as total_orders,
      SUM(sales_amount) as total_sales,
      COUNT(DISTINCT product_key) as total_products,
      MAX(order_date) as last_order,
      TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) as lifespan
FROM base_query
GROUP BY customer_key,
      customer_number,
      customer_name,
      age
)

SELECT customer_key,
      customer_number,
      customer_name,
      age,
     CASE
			WHEN age < 20 THEN 'Under 20'
			WHEN age BETWEEN 20 AND 29 THEN '20-29'
			WHEN age BETWEEN 30 AND 39 THEN '30-39'
			WHEN age BETWEEN 40 AND 49 THEN '40-49'
			ELSE '50 and above'
	 END AS age_group,
	 CASE
			WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
			ELSE 'New'
	  END AS customer_segment,
      total_orders,
	  last_order,
      TIMESTAMPDIFF(MONTH, last_order, CURDATE()) as recency_months,
      total_sales,
      total_products,
      lifespan,
      -- avg order value AOV
      CASE
			WHEN total_orders = 0 THEN 0
			ELSE total_sales / total_orders
	  END AS avg_order_revenue,
-- avg montky spend
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue

FROM customer_aggeration;

SELECT * from gold.report_customers;