
--USE BikeStore;

-----------------------------------
SELECT * FROM brands;

BULK INSERT brands
FROM 'D:\1. Programming\1. MAAB\1. SQL project 2\brands.csv'
WITH (
	FIRSTROW= 2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '\n'
	) 
SELECT * FROM brands;

-----------------------------------
SELECT * FROM categories;

BULK INSERT categories
FROM 'D:\1. Programming\1. MAAB\1. SQL project 2\categories.csv'
WITH (
	FIRSTROW= 2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '\n'
	) 

SELECT * FROM categories;

-----------------------------------
SELECT * FROM stores;

BULK INSERT stores
FROM 'D:\1. Programming\1. MAAB\1. SQL project 2\stores.csv'
WITH (
	FIRSTROW= 2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '\n'
	) 

SELECT * FROM stores;

-----------------------------------
SELECT * FROM customers;

BULK INSERT customers
FROM 'D:\1. Programming\1. MAAB\1. SQL project 2\customers.csv'
WITH (
	FIRSTROW= 2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '\n'
	) 

SELECT * FROM customers;

-----------------------------------
SELECT * FROM staffs;

BULK INSERT staffs
FROM 'D:\1. Programming\1. MAAB\1. SQL project 2\staffs.csv'
WITH (
	FIRSTROW= 2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '\n'
	) 

SELECT * FROM staffs;

-----------------------------------
SELECT * FROM orders;

BULK INSERT orders
FROM 'D:\1. Programming\1. MAAB\1. SQL project 2\orders.csv'
WITH (
	FIRSTROW= 2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '\n'
	) 

SELECT * FROM orders;

-----------------------------------
SELECT * FROM products;

BULK INSERT products
FROM 'D:\1. Programming\1. MAAB\1. SQL project 2\products.csv'
WITH (
	FIRSTROW= 2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '\n'
	) 

SELECT * FROM products;
-----------------------------------
SELECT * FROM stocks;

BULK INSERT stocks
FROM 'D:\1. Programming\1. MAAB\1. SQL project 2\stocks.csv'
WITH (
	FIRSTROW= 2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '\n'
	) 

SELECT * FROM stocks;

-----------------------------------
SELECT * FROM order_items;

BULK INSERT order_items
FROM 'D:\1. Programming\1. MAAB\1. SQL project 2\order_items.csv'
WITH (
	FIRSTROW= 2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '\n'
	) 

SELECT * FROM order_items;

-----------------------------------


