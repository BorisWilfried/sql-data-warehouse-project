/* 

Create Database and schemas;

Script Purpose:
	This script creates a new database named 'DataWarehouse' after checking it it already exosts.
	If the database exists, it is dropped and recreated. Additionally, the script sets up three schemaswithing the database: 'bronze', 'silver', and 'gold'.

WARNING:
	Running this script will drop the entire 'database' if it exists.
	All data on the database will be permenently deleted. Proceed with caution and ensure you proper backups before running the script.

*/

USE master;
GO

--Drop and recreate the 'Datawarehouse' Database
    IF EXIST(SELECT 1 from sys.databases WHERE name = 'DataWarehouse')
BEGIN  
	ALTER DATABASE DataWarehouse SET SINGLE_USER with ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

--crate database Datawarehouse
CREATE DATABASE DataWarehouse;

-- create schema
CREATE SCHEMA bronze; 
GO

CREATE SCHEMA silver; 
GO

CREATE SCHEMA gold; 
