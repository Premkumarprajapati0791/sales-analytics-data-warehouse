/* Analyze the yealy performance of product by comparing their sales.
to both the avg sales performance of the product and the previous year sales */


WITH yearly_product_sales as (
	SELECT YEAR(f.order_date) as order_date,
		   (p.product_name) as product_name,
           SUM(f.price*f.quantity) as revenue
	FROM gold.fact_sales as f
	LEFT JOIN gold.dim_products as p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY product_name,YEAR(f.order_date)
)
SELECT 
	  order_date,
      product_name,
      revenue,
      AVG(revenue) OVER(PARTITION BY product_name) as product_avg,
      revenue - AVG(revenue) OVER(PARTITION BY product_name) as dii_avg,
      CASE 
		  WHEN revenue - AVG(revenue) OVER(PARTITION BY product_name) > 0 THEN 'above_avg'
          WHEN revenue - AVG(revenue) OVER(PARTITION BY product_name) <0 THEN 'below_avg'
          ELSE 'Avg'
	  END AS 'avg_change',
      LAG(revenue) OVER (PARTITION BY product_name ORDER BY order_date) as year_prev,
      revenue - LAG(revenue) OVER (PARTITION BY product_name ORDER BY order_date) as dii_year,
      CASE 
		  WHEN revenue - LAG(revenue) OVER (PARTITION BY product_name ORDER BY order_date) > 0 THEN 'increasing'
          WHEN revenue - LAG(revenue) OVER (PARTITION BY product_name ORDER BY order_date) <0 THEN 'decrseaing'
          ELSE 'no change'
	  END AS 'diff'
from yearly_product_sales
ORDER BY product_name,order_date

