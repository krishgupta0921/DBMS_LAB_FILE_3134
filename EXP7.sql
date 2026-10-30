-- Clean up previous tables
DROP TABLE IF EXISTS Order_Items_BCNF, Salesperson_Product, Order_Items, Orders, Products, Customers, Categories, Sales_Denorm;

-- STEP 0 (UNF): Sales data stored as one repeating group per order (not shown as SQL)
-- STEP 1 (1NF): Flat table with atomic values, key = (Order_ID, Product_ID)
-- Functional dependencies:
--   Order_ID -> Order_Date, Customer_ID, Customer_Name, Customer_City   (partial)
--   Customer_ID -> Customer_Name, Customer_City                         (transitive)
--   Product_ID -> Product_Name, Category, Unit_Price                    (partial)
--   Category -> Category_Manager                                        (transitive)
--   (Order_ID, Product_ID) -> Quantity, Salesperson                     (full)
--   Salesperson -> Product_ID                                           (Salesperson is not a key)

CREATE TABLE Sales_Denorm (
    Order_ID INT,
    Order_Date DATE,
    Customer_ID INT,
    Customer_Name VARCHAR(50),
    Customer_City VARCHAR(50),
    Product_ID INT,
    Product_Name VARCHAR(50),
    Category VARCHAR(50),
    Category_Manager VARCHAR(50),
    Unit_Price DECIMAL(10, 2),
    Quantity INT,
    Salesperson VARCHAR(50),
    PRIMARY KEY (Order_ID, Product_ID)
);

INSERT INTO Sales_Denorm VALUES
(1, '2024-01-15', 1, 'Raj Kumar', 'Delhi', 101, 'Laptop', 'Electronics', 'Sunil', 50000, 1, 'Ravi'),
(1, '2024-01-15', 1, 'Raj Kumar', 'Delhi', 102, 'Shirt', 'Clothing', 'Pooja', 500, 2, 'Meena'),
(2, '2024-01-20', 2, 'Priya Singh', 'Mumbai', 103, 'Phone', 'Electronics', 'Sunil', 20000, 1, 'Arjun'),
(2, '2024-01-20', 2, 'Priya Singh', 'Mumbai', 102, 'Shirt', 'Clothing', 'Pooja', 500, 3, 'Meena'),
(3, '2024-02-02', 1, 'Raj Kumar', 'Delhi', 101, 'Laptop', 'Electronics', 'Sunil', 50000, 1, 'Ravi');

-- STEP 2 and 3 (2NF and 3NF): Remove partial and transitive dependencies
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50),
    Customer_City VARCHAR(50)
);
INSERT INTO Customers SELECT DISTINCT Customer_ID, Customer_Name, Customer_City FROM Sales_Denorm;

CREATE TABLE Categories (
    Category VARCHAR(50) PRIMARY KEY,
    Category_Manager VARCHAR(50)
);
INSERT INTO Categories SELECT DISTINCT Category, Category_Manager FROM Sales_Denorm;

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Order_Date DATE,
    Customer_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);
INSERT INTO Orders SELECT DISTINCT Order_ID, Order_Date, Customer_ID FROM Sales_Denorm;

CREATE TABLE Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(50),
    Category VARCHAR(50),
    Unit_Price DECIMAL(10, 2),
    FOREIGN KEY (Category) REFERENCES Categories(Category)
);
INSERT INTO Products SELECT DISTINCT Product_ID, Product_Name, Category, Unit_Price FROM Sales_Denorm;

CREATE TABLE Order_Items (
    Order_ID INT,
    Product_ID INT,
    Quantity INT,
    Salesperson VARCHAR(50),
    PRIMARY KEY (Order_ID, Product_ID),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);
INSERT INTO Order_Items SELECT Order_ID, Product_ID, Quantity, Salesperson FROM Sales_Denorm;

-- STEP 4 (BCNF): Salesperson -> Product_ID violates BCNF (Salesperson is not a key)
CREATE TABLE Salesperson_Product (
    Salesperson VARCHAR(50) PRIMARY KEY,
    Product_ID INT,
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);
INSERT INTO Salesperson_Product SELECT DISTINCT Salesperson, Product_ID FROM Sales_Denorm;

CREATE TABLE Order_Items_BCNF (
    Order_ID INT,
    Salesperson VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (Order_ID, Salesperson),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Salesperson) REFERENCES Salesperson_Product(Salesperson)
);
INSERT INTO Order_Items_BCNF SELECT Order_ID, Salesperson, Quantity FROM Sales_Denorm;

-- VERIFY 1: Lossless join (3NF). Empty result = no data lost
SELECT s.* FROM Sales_Denorm s
WHERE NOT EXISTS (
    SELECT 1 FROM Order_Items oi
    JOIN Orders o ON oi.Order_ID = o.Order_ID
    JOIN Products p ON oi.Product_ID = p.Product_ID
    JOIN Customers c ON o.Customer_ID = c.Customer_ID
    JOIN Categories cat ON p.Category = cat.Category
    WHERE oi.Order_ID = s.Order_ID AND oi.Product_ID = s.Product_ID
      AND oi.Quantity = s.Quantity AND oi.Salesperson = s.Salesperson
      AND o.Order_Date = s.Order_Date AND c.Customer_Name = s.Customer_Name
      AND c.Customer_City = s.Customer_City AND p.Product_Name = s.Product_Name
      AND p.Unit_Price = s.Unit_Price AND cat.Category_Manager = s.Category_Manager
);

-- VERIFY 2: Lossless join (BCNF). Should return 5 (same as original rows)
SELECT COUNT(*) AS Rebuilt_Rows
FROM Order_Items_BCNF ob
JOIN Salesperson_Product sp ON ob.Salesperson = sp.Salesperson;

-- VERIFY 3: Dependency check on data. Empty result = FD holds
SELECT Customer_ID FROM Sales_Denorm GROUP BY Customer_ID HAVING COUNT(DISTINCT Customer_Name) > 1;
SELECT Product_ID FROM Sales_Denorm GROUP BY Product_ID HAVING COUNT(DISTINCT Unit_Price) > 1;
SELECT Salesperson FROM Sales_Denorm GROUP BY Salesperson HAVING COUNT(DISTINCT Product_ID) > 1;

-- DEPENDENCY PRESERVATION NOTE:
-- (Order_ID, Product_ID) -> Quantity is LOST in BCNF, because Product_ID
-- is no longer stored together with Order_ID in Order_Items_BCNF.
-- This is the known trade-off of BCNF decomposition.
