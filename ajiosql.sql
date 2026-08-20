-- CREATE TABLES AND SET THEIR PRIMARY KEYS

DROP TABLE IF EXISTS Fact_Sales CASCADE;
CREATE TABLE Fact_Sales
(
Sales_ID	CHAR(10) PRIMARY KEY,
Order_ID	CHAR(10),
Order_Date	DATE,
Customer_ID	CHAR(10),
Product_ID	CHAR(10),
Seller_ID	CHAR(10),
Payment_Method_ID	VARCHAR(30),
Coupon_ID	TEXT,
Status_ID	CHAR(15),
Quantity	INT,
Unit_Price	NUMERIC(10,2),
Gross_Amount	NUMERIC(10,2),
Discount_Amount	NUMERIC(10,2),
Delivery_Fee	INT,
Total_Amount NUMERIC(10,2)
)

DROP TABLE IF EXISTS Fact_Returns CASCADE;
CREATE TABLE Fact_Returns
(
Return_ID	CHAR(10) PRIMARY KEY,
Order_ID	CHAR(10),
Sales_ID	CHAR(10),
Customer_ID	CHAR(10),
Product_ID	CHAR(10),
Return_Date	DATE,
Return_Reason	TEXT,
Refund_Amount	NUMERIC(10,2),
Refund_Status TEXT
)

DROP TABLE IF EXISTS Fact_Payments CASCADE;
CREATE TABLE Fact_Payments
(
Payment_Transaction_ID	CHAR(15) PRIMARY KEY,
Order_ID	CHAR(10),
Customer_ID	CHAR(10),
Payment_Method_ID	VARCHAR(30),
Transaction_Date	DATE,
Payment_Amount	NUMERIC(10,2),
Payment_Status	VARCHAR(20),
Gateway_Response TEXT
)

DROP TABLE IF EXISTS Dim_Seller CASCADE;
CREATE TABLE Dim_Seller
(
Seller_ID	CHAR(10) PRIMARY KEY,
Seller_Name	TEXT,
Seller_Rating	NUMERIC(10,2),
Seller_City	TEXT,
Seller_State TEXT
)

DROP TABLE IF EXISTS Dim_Product CASCADE;
CREATE TABLE Dim_Product
(
Product_ID	CHAR(10) PRIMARY KEY,
Product_Name	TEXT,
Product_Image	TEXT,
Category	TEXT,
Sub_Category	TEXT,
Brand	TEXT,
MRP	NUMERIC(10,2),
Selling_Price	NUMERIC(10,2),
Stock_Quantity INT
)

DROP TABLE IF EXISTS Dim_Payment CASCADE;
CREATE TABLE Dim_Payment
(
Payment_Method_ID	VARCHAR(30) PRIMARY KEY,
Payment_Method	TEXT,
Payment_Category TEXT
)

DROP TABLE IF EXISTS Dim_Order_Status CASCADE;
CREATE TABLE Dim_Order_Status
(
Status_ID	CHAR(15) PRIMARY KEY,
Order_Status	TEXT,
Description TEXT
)

DROP TABLE IF EXISTS Dim_Customer CASCADE;
CREATE TABLE Dim_Customer
(
Customer_ID	CHAR(10) PRIMARY KEY,
Customer_Name	TEXT,
Gender	VARCHAR(10),
Email	VARCHAR(255),
Phone	VARCHAR(20),
City	TEXT,
StateName	TEXT,
Signup_Date DATE
)

DROP TABLE IF EXISTS Dim_Coupon CASCADE;
CREATE TABLE Dim_Coupon
(
Coupon_ID	TEXT PRIMARY KEY,
Coupon_Code	TEXT,
Discount_Percentage	INT,
Min_Order_Value INT
)

-- ESTABLISH FOREIGN KEY CONNECTIONS

ALTER TABLE fact_sales
ADD CONSTRAINT fk_sales_customer
FOREIGN KEY(customer_id) REFERENCES dim_customer(customer_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_sales_product
FOREIGN KEY(product_id) REFERENCES dim_product(product_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_sales_seller
FOREIGN KEY(seller_id) REFERENCES dim_seller(seller_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_sales_paymentmethod
FOREIGN KEY(payment_method_id) REFERENCES dim_payment(payment_method_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_sales_coupon
FOREIGN KEY(coupon_id) REFERENCES dim_coupon(coupon_id);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_sales_status
FOREIGN KEY(status_id) REFERENCES dim_order_status(status_id);

-- INSERT DATA INTO TABLES USING IMPORT/EXPORT DATA OPTION
-- VALIDATE DATA LOADED INTO TABLES
select * from fact_sales
select * from fact_returns
select * from fact_payments

select * from dim_coupon
select * from dim_customer
select * from dim_order_status
select * from dim_payment
select * from dim_product
select * from dim_seller

select 'fact_sales' as table_name, COUNT(*) as row_count from fact_sales
UNION ALL
select 'fact_returns',COUNT(*) from fact_returns
UNION ALL
select 'fact_payments', COUNT(*) from fact_payments
UNION ALL
select 'dim_seller', COUNT(*) from dim_seller
UNION ALL
select 'dim_product', COUNT(*) from dim_product
UNION ALL
select 'dim_payment', COUNT(*) from dim_payment
UNION ALL
select 'dim_order_status', COUNT(*) from dim_order_status
UNION ALL
select 'dim_customer', COUNT(*) from dim_customer
UNION ALL
select 'dim_coupon', COUNT(*) from dim_coupon;

-- Create staging Tables
CREATE TABLE fact_sales_stage (LIKE fact_sales);
INSERT INTO fact_sales_stage
SELECT * FROM fact_sales

SELECT * FROM fact_sales_stage;

CREATE TABLE fact_returns_stage (LIKE fact_returns);
INSERT INTO fact_returns_stage
SELECT * FROM fact_returns

SELECT * FROM fact_returns_stage;

CREATE TABLE fact_payments_stage (LIKE fact_payments);
INSERT INTO fact_payments_stage
SELECT * FROM fact_payments

SELECT * FROM fact_payments_stage;

-- ********** Clean Fact Tables ************

-- 1. Fact sales
select * from fact_sales_stage;

-- Count NULL values
select 
COUNT(CASE WHEN sales_id IS NULL THEN 1 END) as salesid_null,
COUNT(CASE WHEN order_id IS NULL THEN 1 END) as orderid_null,
COUNT(CASE WHEN order_date IS NULL THEN 1 END) as orderdate_null,
COUNT(CASE WHEN customer_id IS NULL THEN 1 END) as customerid_null,
COUNT(CASE WHEN product_id IS NULL THEN 1 END) as productid_null,
COUNT(CASE WHEN seller_id IS NULL THEN 1 END) as sellerid_null,
COUNT(CASE WHEN payment_method_id IS NULL THEN 1 END) as payment_method_id_null,
COUNT(CASE WHEN coupon_id IS NULL THEN 1 END) as coupon_id_null,
COUNT(CASE WHEN status_id IS NULL THEN 1 END) as status_id_null,
COUNT(CASE WHEN quantity IS NULL THEN 1 END) as quantity_null,
COUNT(CASE WHEN unit_price IS NULL THEN 1 END) as unitprice_null,
COUNT(CASE WHEN gross_amount IS NULL THEN 1 END) as gross_amount_null,
COUNT(CASE WHEN discount_amount IS NULL THEN 1 END) as discount_amount_null,
COUNT(CASE WHEN delivery_fee IS NULL THEN 1 END) as delivery_fee_null,
COUNT(CASE WHEN total_amount IS NULL THEN 1 END) as totalamt_null
from fact_sales_stage; -- couponid,discountamt and delivery fee has NULL values

-- Check NULL in all columns
select COUNT(*) from fact_sales_stage
WHERE sales_id IS NULL AND order_id IS NULL AND order_date IS NULL AND customer_id IS NULL AND product_id IS NULL
AND seller_id IS NULL AND payment_method_id IS NULL AND coupon_id IS NULL AND status_id IS NULL AND quantity IS NULL
AND unit_price IS NULL AND gross_amount IS NULL AND discount_amount IS NULL AND delivery_fee IS NULL AND total_amount IS NULL;

-- Check for duplicates
SELECT
sales_id, order_id, order_date, customer_id, product_id, seller_id, payment_method_id, coupon_id, status_id, quantity,
unit_price, gross_amount, discount_amount, delivery_fee, total_amount, COUNT(*) as duplicate_count
from fact_sales_stage
GROUP BY sales_id, order_id, order_date, customer_id, product_id, seller_id, payment_method_id, coupon_id, status_id, quantity,
unit_price, gross_amount, discount_amount, delivery_fee, total_amount
HAVING COUNT(*)>1; -- no duplicates found

select * from fact_sales_stage

select DISTINCT(coupon_id) from fact_sales_stage;
select * from fact_sales_stage WHERE coupon_id IS NULL; -- 153 null coupon ids

update fact_sales_stage set coupon_id = 'COUP_NONE' WHERE coupon_id IS NULL;

select DISTINCT(discount_amount) from fact_sales_stage ORDER BY discount_amount NULLS FIRST;
select * from fact_sales_stage WHERE discount_amount IS NULL;
select COUNT(*) from fact_sales_stage WHERE discount_amount IS NULL; -- 151 null discount amount

update fact_sales_stage set discount_amount = 0.00 WHERE discount_amount IS NULL;

select DISTINCT(delivery_fee) from fact_sales_stage ORDER BY delivery_fee NULLS FIRST;
select COUNT(*) from fact_sales_stage WHERE delivery_fee IS NULL; -- 158 null delivery fees

update fact_sales_stage set delivery_fee = 0 WHERE delivery_fee IS NULL;

select DISTINCT product_id from fact_sales_stage ORDER BY product_id;

update fact_sales_stage set sales_id = TRIM(sales_id);
update fact_sales_stage set order_id = TRIM(order_id);
update fact_sales_stage set customer_id = TRIM(customer_id);
update fact_sales_stage set product_id = TRIM(product_id);
update fact_sales_stage set seller_id = TRIM(seller_id);
update fact_sales_stage set payment_method_id = TRIM(payment_method_id);
update fact_sales_stage set status_id = TRIM(status_id);

-- 1. Fact returns
select * from fact_returns_stage;

-- Count NULL values
select 
COUNT(CASE WHEN return_id IS NULL THEN 1 END) as return_id_null,
COUNT(CASE WHEN order_id IS NULL THEN 1 END) as orderid_null,
COUNT(CASE WHEN sales_id IS NULL THEN 1 END) as sales_id_null,
COUNT(CASE WHEN customer_id IS NULL THEN 1 END) as customer_id_null,
COUNT(CASE WHEN product_id IS NULL THEN 1 END) as product_id_null,
COUNT(CASE WHEN return_date IS NULL THEN 1 END) as returndate_null,
COUNT(CASE WHEN return_reason IS NULL THEN 1 END) as return_reason_null,
COUNT(CASE WHEN refund_amount IS NULL THEN 1 END) as refund_amount_null,
COUNT(CASE WHEN refund_status IS NULL THEN 1 END) as refund_status_null
from fact_returns_stage; -- returndate,return reason, refund status has NULL values

-- Check NULL in all columns
select COUNT(*) from fact_returns_stage
WHERE return_id IS NULL AND order_id IS NULL AND sales_id IS NULL AND customer_id IS NULL AND product_id IS NULL
AND return_date IS NULL AND return_reason IS NULL AND refund_amount IS NULL AND refund_status IS NULL;

-- Check duplicates
SELECT
return_id,order_id,sales_id,customer_id,product_id,return_date,return_reason,refund_amount,refund_status, COUNT(*) as duplicate_count
from fact_returns_stage
GROUP BY return_id,order_id,sales_id,customer_id,product_id,return_date,return_reason,refund_amount,refund_status
HAVING COUNT(*)>1; -- no duplicates

select DISTINCT return_date from fact_returns_stage ORDER BY return_date NULLS FIRST;
select COUNT(*) from fact_returns_stage WHERE return_date IS NULL; -- 9 null return dates

select DISTINCT return_reason from fact_returns_stage ORDER BY return_reason NULLS FIRST;
select * from fact_returns_stage WHERE return_reason IS NULL;
select COUNT(*) from fact_returns_stage WHERE return_reason IS NULL; -- 29 null return reasons

update fact_returns_stage set return_reason = 'Not Specified' WHERE return_reason IS NULL;

select return_reason, INITCAP(TRIM(return_reason)) as cleaned from fact_returns_stage;
update fact_returns_stage set return_reason = INITCAP(TRIM(return_reason));
select DISTINCT return_reason, REPLACE(return_reason,'/',' or ') as cleaned from fact_returns_stage;
update fact_returns_stage set return_reason = REPLACE(return_reason,'/',' or ');

select DISTINCT refund_status from fact_returns_stage ORDER BY refund_status NULLS FIRST;
select COUNT(*) from fact_returns_stage WHERE refund_status IS NULL; -- 19 null refund status

update fact_returns_stage set refund_status = 'Unknown' WHERE refund_status IS NULL;

select DISTINCT refund_status, INITCAP(TRIM(refund_status)) as cleaned from fact_returns_stage;
update fact_returns_stage set refund_status = INITCAP(TRIM(refund_status));

select DISTINCT sales_id from fact_returns_stage ORDER BY sales_id

update fact_returns_stage set return_id = TRIM(return_id)
update fact_returns_stage set order_id = TRIM(order_id)
update fact_returns_stage set sales_id = TRIM(sales_id)
update fact_returns_stage set customer_id = TRIM(customer_id)
update fact_returns_stage set product_id = TRIM(product_id)

-- 3. Fact Payments
select * from fact_payments_stage;

-- Count NULL values
select 
COUNT(CASE WHEN payment_transaction_id IS NULL THEN 1 END) as payment_transaction_id_null,
COUNT(CASE WHEN order_id IS NULL THEN 1 END) as orderid_null,
COUNT(CASE WHEN customer_id IS NULL THEN 1 END) as customer_id_null,
COUNT(CASE WHEN payment_method_id IS NULL THEN 1 END) as payment_method_id_null,
COUNT(CASE WHEN transaction_date IS NULL THEN 1 END) as transaction_date_null,
COUNT(CASE WHEN payment_amount IS NULL THEN 1 END) as payment_amount_null,
COUNT(CASE WHEN payment_status IS NULL THEN 1 END) as payment_status_null,
COUNT(CASE WHEN gateway_response IS NULL THEN 1 END) as gateway_response_null
from fact_payments_stage; -- gatewayresponse has NULL values

-- Check NULL in all columns
select COUNT(*) from fact_payments_stage
WHERE payment_transaction_id IS NULL AND order_id IS NULL AND customer_id IS NULL AND payment_method_id IS NULL AND transaction_date IS NULL
AND payment_amount IS NULL AND payment_status IS NULL AND gateway_response IS NULL;

-- Check duplicates
SELECT
payment_transaction_id,order_id,customer_id,payment_method_id,transaction_date,payment_amount,payment_status,gateway_response, COUNT(*) as duplicate_count
from fact_payments_stage
GROUP BY payment_transaction_id,order_id,customer_id,payment_method_id,transaction_date,payment_amount,payment_status,gateway_response
HAVING COUNT(*)>1; -- no duplicates

select DISTINCT gateway_response from fact_payments_stage;
update fact_payments_stage set gateway_response = INITCAP(TRIM(gateway_response));
update fact_payments_stage set gateway_response = 'Unknown' WHERE gateway_response IS NULL;

select DISTINCT payment_status from fact_payments_stage;
select DISTINCT payment_status, INITCAP(TRIM(payment_status)) as cleaned from fact_payments_stage;
update fact_payments_stage set payment_status = INITCAP(TRIM(payment_status));

select DISTINCT payment_method_id from fact_payments_stage;
select DISTINCT payment_method_id, UPPER(TRIM(payment_method_id)) as cleaned from fact_payments_stage;
update fact_payments_stage set payment_method_id = UPPER(TRIM(payment_method_id));

select DISTINCT customer_id from fact_payments_stage;

update fact_payments_stage set payment_transaction_id = TRIM(payment_transaction_id)
update fact_payments_stage set order_id = TRIM(order_id)
update fact_payments_stage set customer_id = TRIM(customer_id)

-- ********** Clean Dim Tables *************
select * from dim_coupon;
update dim_coupon set coupon_id = TRIM(coupon_id);
update dim_coupon set coupon_code = TRIM(coupon_code);

select * from dim_customer;

-- Count NULL values
SELECT
COUNT(CASE WHEN customer_id IS NULL THEN 1 END) as customerid_null,
COUNT(CASE WHEN customer_name IS NULL THEN 1 END) as customer_name_null,
COUNT(CASE WHEN gender IS NULL THEN 1 END) as gender_null,
COUNT(CASE WHEN email IS NULL THEN 1 END) as email_null,
COUNT(CASE WHEN phone IS NULL THEN 1 END) as phone_null,
COUNT(CASE WHEN city IS NULL THEN 1 END) as city_null,
COUNT(CASE WHEN statename IS NULL THEN 1 END) as statename_null,
COUNT(CASE WHEN signup_date IS NULL THEN 1 END) as signup_date_null
from dim_customer; -- email has nulls

-- Check NULL in all columns
select COUNT(*) from dim_customer
WHERE customer_id IS NULL AND customer_name IS NULL AND gender IS NULL AND email IS NULL AND phone IS NULL
AND city IS NULL AND statename IS NULL AND signup_date IS NULL;

-- Check duplicates
SELECT
customer_id,customer_name,gender,email,phone,city,statename,signup_date, COUNT(*) as duplicate_count
from dim_customer
GROUP BY customer_id,customer_name,gender,email,phone,city,statename,signup_date
HAVING COUNT(*)>1; -- no duplicates

select DISTINCT customer_id from dim_customer ORDER BY customer_id NULLS FIRST

select DISTINCT customer_name from dim_customer ORDER BY customer_name NULLS FIRST
select DISTINCT customer_name, INITCAP(TRIM(customer_name)) from dim_customer
update dim_customer set customer_name = INITCAP(TRIM(customer_name))

select DISTINCT gender from dim_customer ORDER BY gender NULLS FIRST
update dim_customer set gender = TRIM(gender)

select DISTINCT email from dim_customer ORDER BY email NULLS FIRST
select * from dim_customer WHERE email IS NULL
select COUNT(*) from dim_customer WHERE email IS NULL -- 30 null email
update dim_customer set email = 'Not available' WHERE email IS NULL

-- validate email
SELECT customer_id, email from dim_customer
WHERE email IS NOT NULL 
  AND email !~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

update dim_customer set email = TRIM(email)

select DISTINCT phone from dim_customer
select phone from dim_customer WHERE LENGTH(TRIM(phone)) <> 10

select DISTINCT city from dim_customer
update dim_customer set city = INITCAP(TRIM(city));

select DISTINCT statename from dim_customer
update dim_customer set statename = TRIM(statename);

select DISTINCT signup_date from dim_customer

select * from dim_order_status;

select DISTINCT status_id from dim_order_status;
select DISTINCT order_status from dim_order_status;
update dim_order_status set status_id = TRIM(status_id);
update dim_order_status set order_status = TRIM(order_status);

select * from dim_payment;

select DISTINCT payment_method_id from dim_payment;
select DISTINCT payment_method from dim_payment;
select DISTINCT payment_method, INITCAP(TRIM(payment_method)) from dim_payment;
update dim_payment set payment_method = INITCAP(TRIM(payment_method))

select payment_method from dim_payment WHERE payment_method='Upi';
update dim_payment set payment_method = 'UPI' WHERE payment_method='Upi';
update dim_payment set payment_category = TRIM(payment_category);

select * from dim_product;
select DISTINCT product_name from dim_product;
select product_name, TRIM(REGEXP_REPLACE(product_name, '\s*-\s*Model\s*\d+.*$', '', 'i')) as clean from dim_product;
update dim_product set product_name = TRIM(REGEXP_REPLACE(product_name, '\s*-\s*Model\s*\d+.*$', '', 'i'));

update dim_product set product_name = INITCAP(product_name);
update dim_product set product_name = 'Noise Smartwatch' WHERE product_name = 'Noise Smartwatche'
update dim_product set product_name = 'Vero Moda Dress' WHERE product_name = 'Vero Moda Dresse'
update dim_product set product_name = 'Fossil Watch' WHERE product_name = 'Fossil Watche'
update dim_product set product_name = 'Gini & Jony Girls Dress' WHERE product_name = 'Gini & Jony Girls Dresse'
update dim_product set product_name = 'Ray-Ban Sunglasses' WHERE product_name = 'Ray-Ban Sunglasse'

select * from dim_product ORDER BY product_id;

select DISTINCT category from dim_product;
update dim_product set category = INITCAP(TRIM(category));
update dim_product set category = 'Men''s Clothing' WHERE category = 'Men''S Clothing'
update dim_product set category = 'Women''s Clothing' WHERE category = 'Women''S Clothing'

select DISTINCT sub_category from dim_product;
update dim_product set sub_category = TRIM(sub_category);

select DISTINCT brand from dim_product;
update dim_product set brand = INITCAP(TRIM(brand));

select DISTINCT stock_quantity from dim_product ORDER BY stock_quantity NULLS FIRST;
select COUNT(*) from dim_product WHERE stock_quantity IS NULL; -- 3 null stock qty
update dim_product set stock_quantity = 0 WHERE stock_quantity IS NULL

select * from dim_seller;
select DISTINCT seller_name from dim_seller;
update dim_seller SET seller_id = TRIM(seller_id);
update dim_seller SET seller_name = INITCAP(TRIM(seller_name));

select DISTINCT seller_city from dim_seller;
select DISTINCT seller_state from dim_seller;
update dim_seller SET seller_city = TRIM(seller_city);
update dim_seller SET seller_state = TRIM(seller_state);

-- Load the updated stage data back to original tables
TRUNCATE TABLE fact_sales,fact_payments,fact_returns CASCADE;

INSERT INTO fact_sales
SELECT * from fact_sales_stage

INSERT INTO fact_returns
SELECT * from fact_returns_stage

INSERT INTO fact_payments
SELECT * from fact_payments_stage

select * from fact_sales;
select * from fact_returns;
select * from fact_payments;

-- SQL joins were used to combine fact and dimension tables for analysis, such as sales by customer, product, seller, and payment method.
-- Also, to confirm if the relationships established were correct.
-- The fact and dimension tables will be kept separate before importing in Power BI to build a star schema.

select * from fact_sales fs
LEFT JOIN dim_customer dc
ON dc.customer_id = fs.customer_id

select * from fact_sales fs
LEFT JOIN dim_product dp
ON dp.product_id = fs.product_id

select * from fact_sales fs
LEFT JOIN dim_seller ds
ON ds.seller_id = fs.seller_id

-- 1. Total sales by product category
select SUM(fs.total_amount) as total_sales,dp.category from fact_sales fs
LEFT JOIN dim_product dp
ON dp.product_id = fs.product_id
GROUP BY dp.category

-- 2. Top 10 Customers by Total Spending
select SUM(fs.total_amount) as total_sales,dc.customer_id,dc.customer_name from fact_sales fs
LEFT JOIN dim_customer dc
ON dc.customer_id = fs.customer_id
GROUP BY dc.customer_id,dc.customer_name
ORDER BY total_sales DESC
LIMIT 10

-- 3. Top Sellers by Revenue
select SUM(fs.total_amount) as total_sales,ds.seller_id,ds.seller_name from fact_sales fs
LEFT JOIN dim_seller ds
ON ds.seller_id = fs.seller_id
GROUP BY ds.seller_id,ds.seller_name
ORDER BY total_sales DESC

-- 4. Sales by Payment Category
select SUM(fs.total_amount) as total_sales,dp.payment_category from fact_sales fs
LEFT JOIN dim_payment dp
ON dp.payment_method_id = fs.payment_method_id
GROUP BY dp.payment_category
ORDER BY total_sales DESC

-- 5. Return Rate by Product Category
WITH Return_rateCTE AS
(
select dp.category as category, COUNT(DISTINCT fs.sales_id) as total_sales, COUNT(DISTINCT fr.sales_id) as returned_sales from fact_sales fs
LEFT JOIN dim_product dp
ON dp.product_id = fs.product_id
LEFT JOIN fact_returns fr
ON fr.sales_id = fs.sales_id
GROUP BY dp.category
)
select  category, total_sales, returned_sales,
CONCAT(ROUND((returned_sales * 100.00)/total_sales,2),' %') as return_rate
from Return_rateCTE

-- CREATE VIEWS FOR ANALYSIS

CREATE OR REPLACE VIEW fact_sales_view AS
select * from fact_sales

select * from fact_sales_view;

CREATE OR REPLACE VIEW fact_returns_view AS
select * from fact_returns

select * from fact_returns_view;

CREATE OR REPLACE VIEW fact_payments_view AS
select payment_transaction_id,order_id,customer_id,payment_method_id,transaction_date,payment_amount,payment_status from fact_payments;

select * from fact_payments_view;

CREATE OR REPLACE VIEW dim_coupon_view AS
select * from dim_coupon

select * from dim_coupon_view;

CREATE OR REPLACE VIEW dim_customer_view AS
select customer_id,customer_name,gender,city,statename as "state",signup_date from dim_customer

select * from dim_customer_view;

CREATE OR REPLACE VIEW dim_order_status_view AS
select status_id,order_status from dim_order_status

select * from dim_order_status_view;

CREATE OR REPLACE VIEW dim_payment_view AS
select * from dim_payment

select * from dim_payment_view;

CREATE OR REPLACE VIEW dim_product_view AS
select * from dim_product

select * from dim_product_view;

CREATE OR REPLACE VIEW dim_seller_view AS
select * from dim_seller

select * from dim_seller_view;