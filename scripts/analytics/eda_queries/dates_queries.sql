-- Date realted question and queries

-- find first order and last order and date, Month and year range
SELECT MIN(order_date) as first_order,
	   MAX(order_date) as last_order,
	   timestampdiff(Year, MIN(order_date), MAX(order_date)) as year_range,
       timestampdiff(Month, MIN(order_date), MAX(order_date)) as year_range,
       datediff(MAX(order_date), MIN(order_date)) as date_diff
from gold.fact_sales;

-- find the youngest and oldest customer
SELECT MIN(birthday) as youngest_age,
	   MAX(birthday) as oldest_age,
       MIN(timestampdiff(year,birthday, curdate())) as youngest_age,
       MAX(timestampdiff(year, birthday, curdate())) oldest_age
FROM gold.dim_customers;

-- age group and its counting 

SELECT 
        CASE 
			WHEN age < 18  then 'Minor' 
            WHEN age BETWEEN 18 AND 25 then 'young'
            WHEN age BETWEEN 26 AND 40 then 'adult'
            WHEN age BETWEEN 41 AND 60 then 'sinor'
            else 'old'
		end as age_group,
        count(*) as count
from
(SELECT 
    TIMESTAMPDIFF(YEAR, birthday, CURDATE()) AS age
FROM
    gold.dim_customers
WHERE
    birthday IS NOT NULL) as a
GROUP BY age_group
ORDER BY count desc;







