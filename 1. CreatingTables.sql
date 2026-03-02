
--CREATE DATABASE BikeStore;
--GO
--USE BikeStore;

--------------------------------------------------------------------------------
DROP TABLE IF EXISTS brands;
GO

CREATE TABLE brands(brand_id INT PRIMARY KEY,
					brand_name VARCHAR(50)
					)

SELECT * FROM brands;
-----------------------------------

DROP TABLE IF EXISTS categories;
GO

CREATE TABLE categories(category_id INT PRIMARY KEY,
						category_name VARCHAR(50)
						)
SELECT * FROM categories


-----------------------------------
DROP TABLE IF EXISTS stores;
GO

CREATE TABLE stores(store_id INT PRIMARY KEY,
					store_name VARCHAR(50),
					phone VARCHAR(50),
					email VARCHAR(50),
					street VARCHAR(50),
					city VARCHAR(50),
					[state] VARCHAR(50),
					zip_code INT
					)

SELECT * FROM stores;

-----------------------------------
DROP TABLE IF EXISTS customers;
GO

CREATE TABLE customers(customer_id INT PRIMARY KEY,
						first_name VARCHAR(50),
						last_name VARCHAR(50),
						phone VARCHAR(50),
						email VARCHAR(50),
						street VARCHAR(50),
						city VARCHAR(50),
						[state] VARCHAR(50),
						zip_code VARCHAR(50)
						)

SELECT * FROM customers;


-----------------------------------
DROP TABLE IF EXISTS staffs;
GO

CREATE TABLE staffs(staff_id INT PRIMARY KEY,
					first_name VARCHAR(50),
					last_name VARCHAR(50),
					email VARCHAR(50),
					phone VARCHAR(50),
					active INT,
					store_id INT,
					manager_id INT NULL,
					FOREIGN KEY(store_id) REFERENCES stores(store_id)
					)

SELECT * FROM staffs;

-----------------------------------
DROP TABLE IF EXISTS orders;
GO

CREATE TABLE orders(order_id INT PRIMARY KEY,
					customer_id INT, 
					order_status INT, 
					order_date DATE,
					required_date DATE,
					shipped_date DATE,
					store_id INT,
					staff_id INT,
					FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
					FOREIGN KEY(store_id) REFERENCES stores(store_id),
					FOREIGN KEY(staff_id) REFERENCES staffs(staff_id)
					)

SELECT * FROM orders;

-----------------------------------
DROP TABLE IF EXISTS products;
GO

CREATE TABLE products(product_id INT PRIMARY KEY,
					product_name VARCHAR(50),
					brand_id INT, 
					category_id INT,
					model_year DATE,
					list_price DECIMAL(10, 2),
					FOREIGN KEY(brand_id) REFERENCES brands(brand_id),
					FOREIGN KEY(category_id) REFERENCES categories(category_id)
					)

SELECT * FROM products

-----------------------------------
DROP TABLE IF EXISTS stocks;
GO

CREATE TABLE stocks(store_id INT,
					product_id INT,
					quantity INT,
					PRIMARY KEY(store_id, product_id),
					FOREIGN KEY(store_id) REFERENCES stores(store_id),
					FOREIGN KEY(product_id) REFERENCES products(product_id)
					)

SELECT * FROM stocks

-----------------------------------
DROP TABLE IF EXISTS order_items;
GO

CREATE TABLE order_items(order_id INT,
						item_id INT,
						product_id INT,
						quantity INT,
						list_price DECIMAL(10, 2),
						discount DECIMAL(5, 2),
						PRIMARY KEY(order_id, item_id),
						FOREIGN KEY(product_id) REFERENCES products(product_id),
						FOREIGN KEY(order_id) REFERENCES orders(order_id)
						)

SELECT * FROM order_items;

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------




--------------------------------------------------------------------------------


--------------------------------------------------------------------------------


