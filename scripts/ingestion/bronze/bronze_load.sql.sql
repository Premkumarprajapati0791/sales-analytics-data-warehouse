-- Enable LOCAL infile for this session
SET GLOBAL local_infile = 1;

-- ERP CUSTOMER
TRUNCATE TABLE bronze.erp_cust_az12;

LOAD DATA LOCAL INFILE 'E:/Prem/Mysql/Sql Data warehouse project/dataset/source_erp/cust_az12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ERP LOCATION
TRUNCATE TABLE bronze.erp_loc_a101;

LOAD DATA LOCAL INFILE 'E:/Prem/Mysql/Sql Data warehouse project/dataset/source_erp/loc_a101.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ERP CATEGORY
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE 'E:/Prem/Mysql/Sql Data warehouse project/dataset/source_erp/px_cat_g1v2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- CRM CUSTOMER
TRUNCATE TABLE bronze.crm_cust_info;

LOAD DATA LOCAL INFILE "E:/Prem/Mysql/Sql Data warehouse project/dataset/source_crm/cust_info.csv"
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- CRM PRODUCT
TRUNCATE TABLE bronze.crm_prd_info;

LOAD DATA LOCAL INFILE "E:/Prem/Mysql/Sql Data warehouse project/dataset/source_crm/prd_info.csv"
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- CRM SALES

TRUNCATE TABLE bronze.crm_sales_details;
LOAD DATA LOCAL INFILE 'E:/Prem/Mysql/Sql Data warehouse project/dataset/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS erp_customer_rows 
FROM bronze.erp_cust_az12;

SELECT COUNT(*) AS erp_location_rows 
FROM bronze.erp_loc_a101;

SELECT COUNT(*) AS erp_category_rows 
FROM bronze.erp_px_cat_g1v2;

SELECT COUNT(*) AS crm_customer_rows 
FROM bronze.crm_cust_info;

SELECT COUNT(*) AS crm_product_rows 
FROM bronze.crm_prd_info;

SELECT COUNT(*) AS crm_sales_rows 
FROM bronze.crm_sales_details;
