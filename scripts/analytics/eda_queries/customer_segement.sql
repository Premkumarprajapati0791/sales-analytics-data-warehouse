/* segment product into cost ranges and
count how many products fall into each sagement */


SELECT cost_range,
	   count(product_key) as total_product
FROM
(SELECT p.product_key as product_key,
	   p.product_name as product_name,
       p.cost as cost,
       CASE
			WHEN cost < 100 THEN '100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'above 1000'
		END AS cost_range
FROM gold.dim_products as p) as product_segment
GROUP BY cost_range
ORDER BY total_product DESC;


/* group customer info into three segemnt on their spending 
-- VIP: costomer with at least 12 month history and spending more than $ 5000.
-- Regular: costomer with at least 12 month history and spending less than $ 5000 or less.
-- New: costomer with a life span less than  12 month
and find the total number of customer by each group */

WITH costomer_spending AS (
	SELECT
	  c.customer_key,
      sum(f.price*quantity) as total_spending,
      MIN(f.order_date) as first_order,
      MAX(f.order_date) as last_order,
      TIMESTAMPDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan
FROM gold.fact_sales as f
LEFT JOIN gold_dim_customers as c
ON f.customer_key = c.customer_key
GROUP BY  c.customer_key)

SELECT customer_segement,
	   count(customer_key) as total
from
(SELECT customer_key,
       CASE
			WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan > 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New Costomer'
		END AS customer_segement
from costomer_spending) AS t
GROUP BY customer_segement
ORDER BY total DESC;
