-- Running Total Revenue by year and month


SELECT yearly,
	   monthly,
	   revenue,
       SUM(revenue) OVER (PARTITION BY yearly ORDER BY month_number) as cumulative_revenue
FROM
(SELECT 
	  YEAR(order_date) as yearly,
      monthname(order_date) as monthly,
      month(order_date) as month_number,
      SUM(price*quantity) as revenue,
      AVG(price*quantity) as moving_avg
FROM gold.fact_sales
WHERE order_date is not NULL
GROUP BY yearly,monthly,month_number ) as a;

