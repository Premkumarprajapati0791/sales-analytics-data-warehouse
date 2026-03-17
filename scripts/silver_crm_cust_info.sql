INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT cst_id,
	   cst_key,
       trim(cst_firstname) AS cst_firstname,
       trim(cst_lastname) AS cst_lastname,
        CASE 
			WHEN upper((trim(cst_marital_status))) = "S" THEN "Single"
			WHEN upper((trim(cst_marital_status))) = "M" THEN "Married"
            ELSE 'Unknown'
		END AS cst_marital_status,
        CASE 
			WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			ELSE 'Unknown'
		END AS cst_gndr,
		CASE
			WHEN CAST(cst_create_date AS CHAR) = '0000-00-00' THEN NULL
			ELSE cst_create_date
		END AS cst_create_date
from
(SELECT *,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
from bronze.crm_cust_info) as a
WHERE flag_last =1 
	  AND 
      cst_id > 0;


select * from silver.crm_cust_info;
