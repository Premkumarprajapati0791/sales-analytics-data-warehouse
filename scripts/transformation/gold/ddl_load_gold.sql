CREATE VIEW gold.dim_customers AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    lo.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE
        WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'Unknown')
    END AS gender,
    ca.bdate AS birthday,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca 
       ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS lo 
       ON ci.cst_key = lo.cid;
       
SELECT *
FROM gold.dim_customers;
 
 
CREATE VIEW gold.dim_products AS
SELECT 	
	   ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt , pn.prd_key) AS product_key,
	   pn.prd_id AS product_id,
	   pn.prd_key AS product_number,
       pn.prd_nm AS product_name,
	   pn.cat_id AS category_id,
       pc.cat AS category,
       pc.subcat AS subcategory,
       pc.maintenance,
       pn.prd_cost AS cost,
       pn.prd_line AS product_line,
       pn.prd_start_dt AS start_date
FROM
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY prd_key
               ORDER BY prd_start_dt DESC
           ) AS rn
    FROM silver.crm_prd_info
) AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE pn.rn = 1;

SELECT * FROM gold.dim_products;

CREATE VIEW gold.fact_sales AS
SELECT sd.sls_ord_num AS order_number,
	   pn.product_key,
       ci.customer_key, 
       sd.sls_order_dt AS order_date,
       sd.sls_ship_dt AS ship_date,
       sd.sls_due_dt AS due_date,
       sd.sls_sales AS sales_amount,
       sd.sls_quantity AS quantity,
       sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS pn
ON sd.sls_prd_key = pn.product_number
LEFT JOIN gold.dim_customers as ci
ON sd.sls_cust_id = ci.customer_id;

SELECT * FROM gold.fact_sales;




