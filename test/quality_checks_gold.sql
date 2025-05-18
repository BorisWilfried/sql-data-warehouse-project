

-- ==========================================================
-- Checking : gold.dim_products
-- ==========================================================
-- Check for uniqueness customer key
-- Expectation: no result

SELECT 
product_key, 
COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1

-- ==========================================================
-- Checking : gold.dim_customerS
-- ==========================================================
-- Check for uniqueness product key
-- Expectation: no result

SELECT 
customer_key, 
COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1

-- ==========================================================
-- Checking : gold.fact_sales
-- ==========================================================
-- check the data model connectivity between fact and dimension 

SELECT 
sls_ord_num AS order_number,
pr.product_key,
ct.customer_key,
sls_order_dt AS order_date,
sls_ship_dt AS shipping_date,
sls_due_dt AS due_date,
sls_sales AS sales_amount,
sls_quantity AS quantity,
sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers ct
ON sd.sls_cust_id = ct.customer_id
WHERE pr.product_key IS NULL OR ct.customer_key IS NULL
