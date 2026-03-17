-------- KPI's -----------------------
-- Total Revenue
-- Find how many item sold
-- find the avg selling price 
-- Total Number of oders
-- Total Number of Product
-- Total no of customers
-- find the total no of customer that has placed an order


SELECT 'Revenue' AS measure_name, Round(SUM(quantity*price),0) as Revenue FROM gold.fact_sales
UNION ALL
SELECT 'total Quantity' AS measure_name,SUM(quantity) AS total_quantity FROM gold.fact_sales
UNION ALL
SELECT 'Avg Price' AS measure_name,ROUND(AVG(sales_amount),0) AS avg_price FROM gold.fact_sales
UNION ALL
SELECT 'Total_orders' AS measure_name,Count(order_number) as Total_orders FROM gold.fact_sales
UNION ALL
SELECT 'num_product'AS measure_name,COUNT(product_number) AS num_product FROM gold.dim_products
UNION ALL
SELECT 'total_num_customer' AS measure_name, COUNT(customer_id) as total_num_customer FROM gold.dim_customers
UNION ALL
SELECT 'total_customers_with_orders' AS measure_name,COUNT(DISTINCT customer_key) AS total_customers_with_orders FROM gold.fact_sales;