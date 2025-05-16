/*
-- '=================================================================================='
--  Quality Check
-- '=================================================================================='
	Script Purpose:
		This script performs various quality checks for Data consistency, accuracy ,
		and standardization across the 'Silver' schema. It includes chechs for :
			- Nulls or Duplicate Primary key
			- unwanted space in String Field
			- Data standardization and consistency
			- Invalid Date Range and Orders
			- Data Consistency between related Fields
	Usage Note : 
		- Run the Checks after Data loading Silver layer.
		- Investicate and resolve discrepencies found during the checks 

	==================================================================================
*/

-- '=================================================================================='
-- Checking : silver.crm_cst_info
-- '=================================================================================='
-- Check for NULLS or Duplicates in the primary key
-- Expectation : no result

SELECT DISTINCT 
   cst_id,
   COUNT(*)
FROM silver.crm_cst_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- CHECK for unwanted Spaces
-- Expectation: no result 

SELECT DISTINCT
    cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key)

-- Data Standardization and consistency

SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info

-- '==================================================================================='
-- Checking : silver.crm_prd_info
-- '=================================================================================='
-- Check for NULLS or Duplicates in the primary key
-- Expectation : no result


SELECT DISTINCT 
   prd_id,
   COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- CHECK for unwanted Spaces
-- Expectation: no result 

SELECT DISTINCT 
   prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- CHECK for NULL OR Negatives Values in cost
-- Expectation: no result 

SELECT DISTINCT 
   prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization and consistency
SELECT DISTINCT 
   prd_line
FROM silver.crm_prd_info

-- Check for invalid Dates Order (Start Date > End Start)
-- Expectation : no result

SELECT 
*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- '==================================================================================='
-- Checking : silver.crm_sales_details
-- '=================================================================================='
-- Check for invalid Dates
-- Expectation : no valid Dates

SELECT 
	NULLIF(sls_due_dt,0) AS sls_due_dt
FROM  bronze.crm_sales_details
WHERE LEN(sls_due_dt) != 8
	  sls_due_dt <= 0
	  sls_due_dt <= 19000101
	  sls_due_dt >= 20500101;


-- check invalid Dates Orders (Orders Dates > shipping/Due Dates)
-- Expectation: no result

SELECT 
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
OR sls_order_dt > sls_due_dt;

-- check Data consistency: Sales + Quantity + Price
-- Expectation: no result
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price

    FROM silver.crm_sales_details
	WHERE sls_sales !=  sls_quantity * sls_price
	OR sls_sales IS NULL
	OR sls_quantity IS NULL
	OR sls_price  IS NULL 
	OR sls_sales <= 0
	OR sls_quantity <= 0
    OR sls_price <= 0
	ORDER BY sls_sales,sls_quantity,sls_price

--'==================================================================================='
-- Checking : silver.erp_cusr_az12
-- '=================================================================================='
-- Idientify Out-of-Range Dates
-- Expectation : Birthday between 1924-01-01 and Today

SELECT DISTINCT 
bdate
FROM silver.erp_cusr_az12
WHere bdate < 1924-01-01
OR bdate > GETDATE();

-- Data Standardization and consistency

SELECT DISTINCT
gen
FROM silver.erp_cusr_az12;

--'==================================================================================='
-- Checking : silver.erp_loc_a101
-- '=================================================================================='
-- Data Standardization and consistency

SELECT DISTINCT 
cntry
FROM silver.erp_loc_a101
ORDER BY cntry

-- '==================================================================================='
-- Checking :silver.erp_px_cat_g1v2
-- '==================================================================================='

-- check for unwanted space
-- Expectation no result
  
SELECT 
*
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance)

-- Data Standardization and consistency
SELECT DISTINCT 
maintenance
FROM silver.erp_px_cat_g1v2
