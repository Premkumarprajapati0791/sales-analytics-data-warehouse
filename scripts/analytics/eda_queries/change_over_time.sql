-- calculate and find which year was best for us in our business

-- using nested queries
SELECT
	  yearly,
      revenue,
      pre_rev,
      (revenue - pre_rev) as diff,
      round((((revenue - pre_rev) / pre_rev) *100),2) as year_growth,
      CASE
			WHEN revenue < pre_rev THEN 'decreasing'
            WHEN revenue > pre_rev THEN 'increasing'
            ELSE 'No Change'
		END as 'change_type'
FROM
(SELECT yearly,
	   revenue,
       Lag(revenue) OVER (ORDER BY yearly) as pre_rev
from 
(SELECT 
		year(order_date) as yearly,
        sum(quantity *price) as revenue
FROM gold.fact_sales 
where year(f.order_date) is not null
group by yearly) as a) as b;


-- using cte's
WITH yearly_sales AS (
    SELECT 
        YEAR(order_date) AS yearly,
        SUM(quantity * price) AS revenue
    FROM gold.fact_sales 
    where year(order_date) is not null
    GROUP BY YEAR(order_date)
)
SELECT *,
       revenue - pre_rev AS diff,
       ROUND(((revenue - pre_rev) / pre_rev) * 100,2) AS year_growth,
       CASE
            WHEN revenue > pre_rev THEN 'increasing'
            WHEN revenue < pre_rev THEN 'decreasing'
            ELSE 'No Change'
       END AS change_type
FROM (
        SELECT *,
               LAG(revenue) OVER (ORDER BY yearly) AS pre_rev
        FROM yearly_sales
) t;








