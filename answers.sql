-- (1) Create a new 1NF table (or view) from the original data

CREATE TABLE ProductDetail_1NF AS
SELECT  OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3
      ) AS numbers
JOIN ProductDetail
      ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n - 1
ORDER BY OrderID, Product;


-- =========================================================
-- Assignment: Database Design and Normalisation
-- File: answers.sql
-- =========================================================

/* ---------------------------------------------------------
   Question 1 – Achieving 1NF 🛠️
   Split the multi-valued “Products” column into individual
   rows so that every intersection contains a single atomic
   value.
----------------------------------------------------------*/
-- (1) Create a new 1NF table (or view) from the original data
CREATE TABLE ProductDetail_1NF AS
SELECT  OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3   -- extend if needed
      ) AS numbers
JOIN ProductDetail
      ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n - 1
ORDER BY OrderID, Product;

-- (If you prefer a VIEW instead of a table, replace CREATE TABLE with CREATE VIEW.)
-- SELECT * FROM ProductDetail_1NF;



/* ---------------------------------------------------------
   Question 2 – Achieving 2NF
----------------------------------------------------------*/
-- (1) Unique list of orders and the customer that placed them
CREATE TABLE Orders (
    OrderID       INT PRIMARY KEY,
    CustomerName  VARCHAR(100) NOT NULL
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM   OrderDetails;

-- (2) Remaining columns form the true order-line table
CREATE TABLE OrderLines (
    OrderID   INT,
    Product   VARCHAR(100),
    Quantity  INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderLines (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM   OrderDetails;