
--USE BikeStore;

-----------------------------------
--SELECT * FROM brands;
--SELECT * FROM categories;
--SELECT * FROM stores;
--SELECT * FROM customers;
--SELECT * FROM staffs;
--SELECT * FROM orders;
--SELECT * FROM products;
--SELECT * FROM stocks;
--SELECT * FROM order_items;

-----------------------------------
--DROP VIEW IF EXISTS vw_StoreSalesSummary;
--GO

--CREATE VIEW vw_StoreSalesSummary 
--AS
--SELECT 
--    s.store_id,
--    s.store_name,
--    COUNT(DISTINCT o.order_id) AS total_orders,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
--    CASE 
--        WHEN COUNT(DISTINCT o.order_id) = 0 THEN 0
--        ELSE SUM(oi.quantity * oi.list_price * (1 - oi.discount)) 
--             / COUNT(DISTINCT o.order_id)
--    END AS avg_order_value
--FROM stores s
--LEFT JOIN orders o ON s.store_id = o.store_id
--LEFT JOIN order_items oi ON o.order_id = oi.order_id
--GROUP BY s.store_id, s.store_name;
--GO

--SELECT * FROM vw_StoreSalesSummary
--------------------------------------------------------------------------------
--DROP VIEW IF EXISTS vw_TopSellingProducts;
--GO

--CREATE VIEW vw_TopSellingProducts AS
--SELECT 
--    p.product_id,
--    p.product_name,
--    SUM(oi.quantity) AS total_quantity_sold,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
--    RANK() OVER (ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC) AS revenue_rank
--FROM products p
--JOIN order_items oi ON p.product_id = oi.product_id
--GROUP BY p.product_id, p.product_name;
--GO

--SELECT * FROM vw_TopSellingProducts

--------------------------------------------------------------------------------
--DROP VIEW IF EXISTS vw_InventoryStatus;
--GO

--CREATE OR ALTER VIEW vw_InventoryStatus AS
--SELECT 
--    st.store_id,
--    st.product_id,
--    p.product_name,
--    st.quantity,
--    CASE 
--        WHEN st.quantity < 5 THEN 'LOW'
--        ELSE 'OK'
--    END AS stock_status
--FROM stocks st
--JOIN products p ON st.product_id = p.product_id;
--GO

--SELECT * FROM vw_InventoryStatus;

--------------------------------------------------------------------------------
--DROP VIEW IF EXISTS vw_StaffPerformance;
--GO

--CREATE VIEW vw_StaffPerformance AS
--SELECT 
--    st.staff_id,
--    st.first_name + ' ' + st.last_name AS staff_name,
--    COUNT(DISTINCT o.order_id) AS total_orders,
--    ISNULL(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0) AS total_revenue
--FROM staffs st
--LEFT JOIN orders o ON st.staff_id = o.staff_id
--LEFT JOIN order_items oi ON o.order_id = oi.order_id
--GROUP BY st.staff_id, st.first_name, st.last_name;
--GO

--SELECT * FROM vw_StaffPerformance;


--------------------------------------------------------------------------------
--DROP VIEW IF EXISTS vw_RegionalTrends;
--GO

--CREATE OR ALTER VIEW vw_RegionalTrends AS
--SELECT 
--    c.city,
--    c.[state],
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
--    COUNT(DISTINCT o.order_id) AS total_orders
--FROM customers c
--JOIN orders o ON c.customer_id = o.customer_id
--JOIN order_items oi ON o.order_id = oi.order_id
--GROUP BY c.city, c.[state];
--GO

--SELECT * FROM vw_RegionalTrends

--------------------------------------------------------------------------------
--DROP VIEW IF EXISTS vw_SalesByCategory;
--GO

--CREATE VIEW vw_SalesByCategory AS
--SELECT 
--    cat.category_id,
--    cat.category_name,
--    SUM(oi.quantity) AS total_quantity_sold,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
--FROM categories cat
--JOIN products p ON cat.category_id = p.category_id
--JOIN order_items oi ON p.product_id = oi.product_id
--GROUP BY cat.category_id, cat.category_name;
--GO

--SELECT * FROM vw_SalesByCategory;

--------------------------------------------------------------------------------
--DROP VIEW IF EXISTS vw_MonthlySalesTrend;
--GO

--CREATE VIEW vw_MonthlySalesTrend AS
--SELECT 
--    YEAR(o.order_date) AS sales_year,
--    MONTH(o.order_date) AS sales_month,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
--    COUNT(DISTINCT o.order_id) AS total_orders
--FROM orders o
--JOIN order_items oi ON o.order_id = oi.order_id
--GROUP BY YEAR(o.order_date), MONTH(o.order_date)
--GO

--SELECT * FROM vw_MonthlySalesTrend
--ORDER BY sales_year, sales_month;

--------------------------------------------------------------------------------
--DROP VIEW IF EXISTS vw_CustomerLifetimeValue;
--GO

--CREATE VIEW vw_CustomerLifetimeValue AS
--SELECT
--    c.customer_id,
--    c.first_name + ' ' + c.last_name AS customer_name,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
--    COUNT(DISTINCT o.order_id) AS total_orders,
--    AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS avg_order_value
--FROM customers c
--LEFT JOIN orders o ON c.customer_id = o.customer_id
--LEFT JOIN order_items oi ON o.order_id = oi.order_id
--GROUP BY c.customer_id, c.first_name, c.last_name;
--GO

--SELECT * FROM vw_CustomerLifetimeValue;

--------------------------------------------------------------------------------
--DROP VIEW IF EXISTS vw_ProductProfitability;
--GO

--CREATE VIEW vw_ProductProfitability AS
--SELECT
--    p.product_id,
--    p.product_name,
--    SUM(oi.quantity) AS total_units_sold,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * 0.30 AS estimated_profit
--FROM products p
--JOIN order_items oi ON p.product_id = oi.product_id
--GROUP BY p.product_id, p.product_name;
--GO

--SELECT * FROM vw_ProductProfitability;

--------------------------------------------------------------------------------
--DROP PROCEDURE IF EXISTS sp_CalculateStoreKPI;
--GO

--CREATE PROCEDURE sp_CalculateStoreKPI
--    @StoreID INT
--AS
--BEGIN
--    SET NOCOUNT ON;

--    SELECT 
--        s.store_id,
--        s.store_name,

--        -- Total Orders
--        COUNT(DISTINCT o.order_id) AS total_orders,

--        -- Total Revenue
--        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,

--        -- AOV
--        CASE 
--            WHEN COUNT(DISTINCT o.order_id) = 0 THEN 0
--            ELSE SUM(oi.quantity * oi.list_price * (1 - oi.discount)) 
--                 / COUNT(DISTINCT o.order_id)
--        END AS avg_order_value,

--        -- Number of Staff
--        (SELECT COUNT(*) FROM staffs WHERE store_id = s.store_id) AS total_staff
--    FROM stores s
--    LEFT JOIN orders o ON s.store_id = o.store_id
--    LEFT JOIN order_items oi ON o.order_id = oi.order_id
--    WHERE s.store_id = @StoreID
--    GROUP BY s.store_id, s.store_name;
--END;
--GO

--EXEC sp_CalculateStoreKPI 2

--------------------------------------------------------------------------------
--DROP PROCEDURE IF EXISTS sp_GenerateRestockList;
--GO

--CREATE PROCEDURE sp_GenerateRestockList
--    @StoreID INT,
--    @Threshold INT = 5   -- Default low stock threshold
--AS
--BEGIN
--    SET NOCOUNT ON;

--    SELECT 
--        st.store_id,
--        st.product_id,
--        p.product_name,
--        st.quantity
--    FROM stocks st
--    JOIN products p ON st.product_id = p.product_id
--    WHERE st.store_id = @StoreID
--      AND st.quantity < @Threshold
--    ORDER BY st.quantity ASC;
--END;
--GO

--EXEC sp_GenerateRestockList 1, 10;

--------------------------------------------------------------------------------
--DROP PROCEDURE IF EXISTS sp_CompareSalesYearOverYear;
--GO

--CREATE PROCEDURE sp_CompareSalesYearOverYear
--    @Year1 INT,
--    @Year2 INT
--AS
--BEGIN
--    SET NOCOUNT ON;

--    SELECT 
--        YearLabel,
--        SUM(revenue) AS total_revenue,
--        COUNT(DISTINCT order_id) AS total_orders
--    FROM (
--        SELECT 
--            CASE WHEN YEAR(o.order_date) = @Year1 THEN CONCAT(@Year1, '') ELSE CONCAT(@Year2, '') END AS YearLabel,
--            o.order_id,
--            oi.quantity * oi.list_price * (1 - oi.discount) AS revenue
--        FROM orders o
--        JOIN order_items oi ON o.order_id = oi.order_id
--        WHERE YEAR(o.order_date) IN (@Year1, @Year2)
--    ) AS yearly
--    GROUP BY YearLabel;
--END;
--GO

--EXEC sp_CompareSalesYearOverYear 2016, 2017;


--------------------------------------------------------------------------------
--DROP PROCEDURE IF EXISTS sp_GetCustomerProfile;
--GO

--CREATE PROCEDURE sp_GetCustomerProfile
--    @CustomerID INT
--AS
--BEGIN
--    SET NOCOUNT ON;

--    -- Summary
--    SELECT 
--        c.customer_id,
--        c.first_name + ' ' + c.last_name AS customer_name,
--        COUNT(DISTINCT o.order_id) AS total_orders,
--        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent,
--        AVG(oi.quantity * oi.list_price * (1 - oi.discount)) AS avg_order_value
--    FROM customers c
--    LEFT JOIN orders o ON c.customer_id = o.customer_id
--    LEFT JOIN order_items oi ON o.order_id = oi.order_id
--    WHERE c.customer_id = @CustomerID
--    GROUP BY c.customer_id, c.first_name, c.last_name;

--    -- Most Bought Item
--    SELECT TOP 1
--        p.product_id,
--        p.product_name,
--        SUM(oi.quantity) AS quantity_bought
--    FROM orders o
--    JOIN order_items oi ON o.order_id = oi.order_id
--    JOIN products p ON oi.product_id = p.product_id
--    WHERE o.customer_id = @CustomerID
--    GROUP BY p.product_id, p.product_name
--    ORDER BY SUM(oi.quantity) DESC;
--END;
--GO

--EXEC sp_GetCustomerProfile 23;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--SELECT 
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
--FROM order_items oi;

--------------------------------------------------------------------------------
--SELECT 
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) 
--        / COUNT(DISTINCT o.order_id) AS AOV
--FROM orders o
--JOIN order_items oi ON o.order_id = oi.order_id;

--------------------------------------------------------------------------------
--SELECT 
--    p.product_id,
--    p.product_name,
--    SUM(oi.quantity) AS units_sold,
--    AVG(st.quantity) AS avg_stock,
--    CASE 
--        WHEN AVG(st.quantity) = 0 THEN NULL
--        ELSE SUM(oi.quantity) / AVG(st.quantity)
--    END AS inventory_turnover
--FROM products p
--LEFT JOIN order_items oi ON p.product_id = oi.product_id
--LEFT JOIN stocks st ON p.product_id = st.product_id
--GROUP BY p.product_id, p.product_name;

--------------------------------------------------------------------------------
--SELECT 
--    s.store_id,
--    s.store_name,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
--FROM stores s
--JOIN orders o ON s.store_id = o.store_id
--JOIN order_items oi ON o.order_id = oi.order_id
--GROUP BY s.store_id, s.store_name
--ORDER BY total_revenue DESC;

--------------------------------------------------------------------------------
--SELECT 
--    c.category_id,
--    c.category_name,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) * 0.30 AS gross_profit
--FROM categories c
--JOIN products p ON c.category_id = p.category_id
--JOIN order_items oi ON p.product_id = oi.product_id
--GROUP BY c.category_id, c.category_name;


--------------------------------------------------------------------------------
--SELECT 
--    b.brand_id,
--    b.brand_name,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
--FROM brands b
--JOIN products p ON b.brand_id = p.brand_id
--JOIN order_items oi ON p.product_id = oi.product_id
--GROUP BY b.brand_id, b.brand_name
--ORDER BY total_sales DESC;

--------------------------------------------------------------------------------
--SELECT 
--    st.staff_id,
--    st.first_name + ' ' + st.last_name AS staff_name,
--    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue_generated,
--    COUNT(DISTINCT o.order_id) AS orders_handled
--FROM staffs st
--LEFT JOIN orders o ON st.staff_id = o.staff_id
--LEFT JOIN order_items oi ON o.order_id = oi.order_id
--GROUP BY st.staff_id, st.first_name, st.last_name
--ORDER BY revenue_generated DESC;


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



-----------------------------------

-----------------------------------
-----------------------------------

-----------------------------------

-----------------------------------

-----------------------------------

-----------------------------------

