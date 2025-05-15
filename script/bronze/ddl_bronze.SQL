/*
==========================================================
DDL Script : Create Bronze Table
==========================================================

Script purpose :
        This script create Tables in the 'bronze' Schema, dropping existing Tables if they already exists.
        Run this Script to re-defind the DDL Structure of the 'bronze' Tables
==========================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==================================================================================='
		PRINT 'Loading Bronze Layer';
		PRINT '==================================================================================='

		PRINT '-----------------------------------------------------------------------------------'
		PRINT 'Loading crm table';
		PRINT '-----------------------------------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '> Inserting Data in the table = bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\youta\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '-------------------------'

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '> Inserting Data in the table = bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\youta\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '-------------------------'

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '> Inserting Data in the table = bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\youta\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '-------------------------'

		PRINT '-----------------------------------------------------------------------------------'
		PRINT 'Loading erp table';
		PRINT '-----------------------------------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = bronze.erp_cusr_az12';
		TRUNCATE TABLE bronze.erp_cusr_az12;
		PRINT '> Inserting Data in the table = bronze.erp_cusr_az12';
		BULK INSERT bronze.erp_cusr_az12
		FROM 'C:\Users\youta\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '-------------------------'

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '> Inserting Data in the table = bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\youta\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '-------------------------'

		SET @start_time = GETDATE();
		PRINT '> Truncating the table = bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '> Inserting Data in the table = bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\youta\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
	); 
		SET @end_time = GETDATE();
		PRINT 'Loading Duration ' + CAST(DATEDIFF (second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '-------------------------'

		SET @batch_end_time = GETDATE();
		PRINT '=================================='
		PRINT 'Loading Bronze Layer is Complete';
		PRINT '>> Total Load Duration ' + CAST(DATEDIFF(second, @batch_start_time,@batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT '=================================='
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
