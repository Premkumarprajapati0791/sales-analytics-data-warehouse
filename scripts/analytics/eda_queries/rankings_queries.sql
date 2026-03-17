-- ranking analysis

-- which 5 product genrate the higest revenue

SELECT 
		p.product_name AS product,
		sum(f.price*f.quantity) as revenue
FROM gold.fact_sales  as f
LEFT JOIN gold.dim_products as p
ON f.product_key = p.product_key
GROUP BY product
ORDER BY revenue DESC
LIMIT 5;

SELECT product,
	   revenue,
       rnk
from 
(SELECT 
		p.product_name AS product,
		sum(f.price*f.quantity) as revenue,
        DENSE_RANK() OVER( ORDER BY sum(f.price*f.quantity) DESC) as rnk
FROM gold.fact_sales  as f
LEFT JOIN gold.dim_products as p
ON f.product_key = p.product_key
GROUP BY product) as a
WHERE rnk<=5;


-- which 5 product genrate the wrost revenue

SELECT 
		p.product_name AS product,
		sum(f.price*f.quantity) as revenue
FROM gold.fact_sales  as f
LEFT JOIN gold.dim_products as p
ON f.product_key = p.product_key
GROUP BY product
ORDER BY revenue 
LIMIT 5;

-- which 5 subcategory genrate the wrost revenue

SELECT 
		p.subcategory AS subcategory,
		sum(f.price*f.quantity) as revenue
FROM gold.fact_sales  as f
LEFT JOIN gold.dim_products as p
ON f.product_key = p.product_key
GROUP BY subcategory
ORDER BY revenue 
LIMIT 5;

-- find the top ten customer who has genrated higest revenue and 3 customer who has fewest orders 

SELECT 
	  c.first_name,
      c.last_name,
	  sum(f.quantity*f.price) as revenue
from gold.fact_sales as f
LEFT JOIN gold.dim_customers as c
ON f.customer_key = c.customer_key
GROUP BY  c.first_name,
      c.last_name
ORDER BY revenue DESC
LIMIT 10;

SELECT *
from
(SELECT 
	  c.first_name,
      c.last_name,
	  sum(f.quantity*f.price) as revenue,
      ROW_NUMBER() OVER (ORDER BY sum(f.quantity*f.price) desc) as rnk
from gold.fact_sales as f
LEFT JOIN gold.dim_customers as c
ON f.customer_key = c.customer_key
GROUP BY  c.first_name,
      c.last_name) as a
where rnk<=10;


-- 3 customer who has fewest orders 
SELECT 
	  c.first_name,
      c.last_name,
	  COUNT(order_number) as orders
from gold.fact_sales as f
LEFT JOIN gold.dim_customers as c
ON f.customer_key = c.customer_key
GROUP BY  c.first_name,
      c.last_name
ORDER BY orders
LIMIT 3
