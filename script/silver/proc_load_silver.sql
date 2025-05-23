/*
=======================================================================================
Store Procedure : Load Bronze Layer (Bronze -> Silver)
=======================================================================================
Script Purpose :
        This stored procedure performs the ETL (EXTRACT,TRANSFORM,LOAD) process
        to populate the 'silver' schema Table from the 'bronze' schema
        Actions PERFORMED:
        - Truncates the sILVER Tables before loading Data
        - INSERT transformed and Cleansed Data from the Bronze into the Silver Tables.
Parameters: 
          None, this stored procedure does not accept any parameter or return any value.

Usage Exemple: 
        EXEC silver.load_silver;
=======================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==================================================================================='
		PRINT 'Loading Silver Layer';
		PRINT '==================================================================================='

		PRINT '-----------------------------------------------------------------------------------'
		PRINT 'Loading crm table';
		PRINT '-----------------------------------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '> Inserting Data in the table = silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info (
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_marital_status,
				cst_gndr,
				cst_create_date
				)
		SELECT 

		cst_id,
		TRIM(cst_key),
		TRIM(cst_firstname) AS cst_firstname,  -- Removing uneccesary space from the NVARCHAR
		TRIM(cst_lastname) AS cst_lastname,
		CASE 
			WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			ELSE 'unknown'
		END cst_marital_status,       -- Normalize marital status Values to readable format
		CASE 
			WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			ELSE 'unknown'
		END cst_gndr,       -- Normalize gender Values to readable format
		cst_create_date
		FROM
		(
		SELECT 

		*, 
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL             -- Select the most recent record per customers and Eliminate duplicated id's
		)p
		WHERE flag = 1;
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------'

		PRINT '============================================================================='

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '> Inserting Data in the table = silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info (
			prd_id ,
			cat_id ,
			prd_key ,
			prd_nm ,
			prd_cost ,
			prd_line ,
			prd_start_dt ,
			prd_end_dt 	
		)
		SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key,1,5), '-', '_')  AS cat_id,   -- Extract category id
		SUBSTRING(prd_key,7,LEN(prd_key))  AS prd_key,          -- Extract product key
		prd_nm,
		ISNULL(prd_cost, 0) AS prd_cost,
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'unknown'
		END prd_line,      -- Map product line to descriptives Values 
		CAST(prd_start_dt AS DATE) AS prd_start_dt,
		CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt )-1 AS DATE )AS prd_end_dt  -- Calculate End Date as One day before the next start Date
		FROM bronze.crm_prd_info;
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------'

		PRINT '============================================================================='

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details
		PRINT '> Inserting Data in the table = silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details(
		
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				sls_order_dt,
				sls_ship_dt,
				sls_due_dt,
				sls_sales,
				sls_quantity,
				sls_price
		)
		SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE
			WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
			ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END AS sls_order_dt,
		CASE
			WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
			ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END AS sls_ship_dt,
		CASE
			WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
			ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END AS sls_due_dt,
		CASE 
			WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales!=  sls_quantity * ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales                                 
		END  AS sls_sales,                     -- recalculate sales if Original Value is missing ou incorrect
		sls_quantity,
		CASE 
			WHEN sls_price IS NULL OR sls_price <= 0 
			THEN sls_sales / NULLIF( sls_quantity, 0)
			ELSE sls_price
		END  AS sls_price                       -- Derieved price if the value is invalid
		FROM bronze.crm_sales_details; 
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------'

		PRINT '==================================================================================='
		PRINT 'Loading Silver Layer';
		PRINT '==================================================================================='

		PRINT '-----------------------------------------------------------------------------------'
		PRINT 'Loading erp table';
		PRINT '-----------------------------------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = silver.erp_cusr_az12';
		TRUNCATE TABLE silver.erp_cusr_az12
		PRINT '> Inserting Data in the table = silver.erp_cusr_az12';
		INSERT INTO silver.erp_cusr_az12(
				cid,
				bdate,
				gen
		)
		SELECT 
		CASE 
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4, LEN(cid))         -- Remove 'NAS' prefix if present
			ELSE cid
		END AS cid,
		CASE 
			WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
		END AS bdate,                 -- set Future Birthdate to Null
		CASE 
			WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
			ELSE 'unknown'
		END AS gen                            -- Normalize gender Values and handles unknown cases
		FROM bronze.erp_cusr_az12;
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------'

		PRINT '============================================================================='

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101
		PRINT '> Inserting Data in the table = silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101(
				cid,
				cntry
		)
		SELECT 
		REPLACE(cid,'-','') cid,
		CASE	
			WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US','USA') THEN 'United State'
			WHEN TRIM(cntry) IS NULL OR cntry = '' THEN 'unknown'
			ELSE TRIM(cntry)
		END AS cntry                 -- Normalize and handle the Blank or missing country codes
		FROM bronze.erp_loc_a101;
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------'

		PRINT '============================================================================='

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		PRINT '> Inserting Data in the table = silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT 
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------'

	END TRY
	BEGIN CATCH 
	PRINT '==================================================================================='
		PRINT 'Error Occured During Loading Bronze Layer';
		PRINT 'Error Message ' + ERROR_MESSAGE();
		PRINT 'Error Message ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '==================================================================================='
	END CATCH
END
