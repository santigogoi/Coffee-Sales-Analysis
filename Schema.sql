CREATE DATABASE coffee_sales_db;
USE coffee_sales_db;

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS city;

CREATE TABLE city(
    city_id	VARCHAR(15) PRIMARY KEY,
	city_name VARCHAR(15),	
	population	BIGINT,
	estimated_rent	FLOAT,
	city_rank INT
);
select COUNT(*) from city;

CREATE TABLE customers(
	customer_id INT PRIMARY KEY,	
	customer_name VARCHAR(25),	
	city_id VARCHAR(15),
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);
select COUNT(*) from customers;

CREATE TABLE products(
	product_id	INT PRIMARY KEY,
	product_name VARCHAR(35),	
	Price float
);
select COUNT(*) from products;

CREATE TABLE sales(
	sale_id	INT PRIMARY KEY,
	sale_date	date,
	product_id	INT,
	customer_id	INT,
	total FLOAT,
	rating INT,
	CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);
select COUNT(*) from sales;