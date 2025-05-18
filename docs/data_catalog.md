Data Dictionary for The Gold Layer

Overview 
The Gold Layer is the Business level Data representation, structured to support analytical and report use cases. It consist of dimention tabels and
fact tables for specific business metrics

📘 Table: gold.dim_customers
Represents cleaned and enriched customer information.

**************************************************************************************************************************************************
Column Name	           Data Type	         Description	                                         Expected Result / Value
**************************************************************************************************************************************************
customer_id	           INT	               ID from source system	                               e.g., "00123"
customer_number	       VARCHAR	           Unified number across systems	                       e.g., "10001"
first_name	           VARCHAR	           Customer's first name	                               Trimmed and capitalized string
last_name	             VARCHAR	           Customer's last name	                                 Trimmed and capitalized string
country	               VARCHAR	           Country of the customer	                             Standardized country name (e.g., "Germany")
marital_status	       VARCHAR	           Marital status in full form	                         "Married", "Single", or "Unknown"
gender	               VARCHAR	           Full gender value	                                   "Male", "Female", or "Unknown"
birthdate	             DATE	               Date of birth	                                        Valid and cleaned date
create_date	           DATE	               When the customer was added to the system	            Standardized date format


📙 Table: gold.dim_products
Stores product information from the ERP or CRM systems, cleaned and enriched.

**************************************************************************************************************************************************
Column Name	          Data Type	           Description	                                          Expected Result / Value
**************************************************************************************************************************************************
product_id	          INT                  Original ID from source	                              e.g., "100"
product_number	      NVARCHAR	           Standardized product number	                          e.g., "20001"
product_name	        NVARCHAR	           Name of the product	                                  Cleaned, trimmed name
category_id	          NVARCHAR             Identifier of the product's category	                  e.g., "CAT01"
category	            NVARCHAR	           Category name	                                        e.g., "Electronics"
subcategory          	NVARCHAR	           Sub-category within the category	                      e.g., "Peripherals"
maintenance	          NVARCHAR	           Maintenance requirement status	                        "Yes", "No", or "Unknown"
product_cost	        INT	                 Cost of the product	                                  e.g., 25
product_line	        NVARCHAR	           Family or group the product belongs to	                e.g., "Mountain", "ROAD"
start_date	          DATE	               Date the product was introduced	                      Valid, standardized date



📗 Table: gold.fact_sales
Fact table holding the transactional data between customers and products.

****************************************************************************************************************************************************
Column Name	         Data Type	           Description	                                          Expected Result / Value
****************************************************************************************************************************************************
order_number	       NVARCHAR	             Business identifier for the order	                    e.g., "ORD12345"
product_key	         INT	                 FK referencing dim_products(product_key)	              Valid foreign key
customer_key	       INT	                 FK referencing dim_customers(customer_key)	            Valid foreign key
order_date	         DATE                  Date the order was placed	                            Must be ≤ shipping and due date
shipping_date	       DATE	                 Date the product was shipped	                          Must be ≥ order_date
due_date	           DATE	                 Expected delivery date	                                Must be ≥ order_date
sales_amount	       INT	                 Total amount = quantity * price	Calculated            value, e.g., 199
quantity	           INT	                 Number of units sold	                                  e.g., 2, 10, always ≥ 1
price	               INT	                 Price per unit at time of order	                      e.g., 2, 10, always ≥ 1


