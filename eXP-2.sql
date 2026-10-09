CREATE DATABASE DBMS_LABFILE_3134;
USE DBMS_LABFILE_3134;

-- Create Customer table
CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    UNIQUE(Customer_ID)
);

-- Create Category table
CREATE TABLE Category (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL,
    UNIQUE(Category_ID)
);

-- Create Product table
CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Category_ID INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID) ON DELETE CASCADE
);

-- Create Seller table
CREATE TABLE Seller (
    Seller_ID INT PRIMARY KEY,
    Seller_Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    UNIQUE(Seller_ID)
);

-- Create Payment table
CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY,
    Payment_Method VARCHAR(50) NOT NULL,
    UNIQUE(Payment_ID)
);

-- Create Delivery table
CREATE TABLE Delivery (
    Delivery_ID INT PRIMARY KEY,
    Delivery_Address VARCHAR(255) NOT NULL,
    Delivery_Status VARCHAR(50) NOT NULL,
    UNIQUE(Delivery_ID)
);

-- Create Order table
CREATE TABLE `Order` (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Order_Date DATE NOT NULL,
    Payment_ID INT NOT NULL,
    Delivery_ID INT NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE,
    FOREIGN KEY (Payment_ID) REFERENCES Payment(Payment_ID) ON DELETE CASCADE,
    FOREIGN KEY (Delivery_ID) REFERENCES Delivery(Delivery_ID) ON DELETE CASCADE
);

-- Create OrderItem table (junction table for Order and Product)
CREATE TABLE OrderItem (
    OrderItem_ID INT PRIMARY KEY,
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Seller_ID INT NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Order_ID) REFERENCES `Order`(Order_ID) ON DELETE CASCADE,
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID) ON DELETE CASCADE,
    FOREIGN KEY (Seller_ID) REFERENCES Seller(Seller_ID) ON DELETE CASCADE
);

-- Insert Categories
INSERT INTO Category VALUES (1, 'Electronics');
INSERT INTO Category VALUES (2, 'Clothing');
INSERT INTO Category VALUES (3, 'Books');

-- Insert Products
INSERT INTO Product VALUES (101, 'Laptop', 1, 50000.00);
INSERT INTO Product VALUES (102, 'Shirt', 2, 500.00);
INSERT INTO Product VALUES (103, 'Novel', 3, 300.00);

-- Insert Customers
INSERT INTO Customer VALUES (1001, 'Raj Kumar', 'Delhi');
INSERT INTO Customer VALUES (1002, 'Priya Singh', 'Mumbai');
INSERT INTO Customer VALUES (1003, 'Amit Patel', 'Bangalore');

-- Insert Sellers
INSERT INTO Seller VALUES (2001, 'Tech Store', 'Delhi');
INSERT INTO Seller VALUES (2002, 'Fashion Hub', 'Mumbai');

-- Insert Payment Methods
INSERT INTO Payment VALUES (3001, 'Credit Card');
INSERT INTO Payment VALUES (3002, 'Debit Card');
INSERT INTO Payment VALUES (3003, 'UPI');

-- Insert Delivery
INSERT INTO Delivery VALUES (4001, 'Delhi', 'Delivered');
INSERT INTO Delivery VALUES (4002, 'Mumbai', 'Pending');
INSERT INTO Delivery VALUES (4003, 'Bangalore', 'In Transit');

-- Insert Orders
INSERT INTO `Order` VALUES (5001, 1001, '2024-01-15', 3001, 4001);
INSERT INTO `Order` VALUES (5002, 1002, '2024-01-20', 3002, 4002);
INSERT INTO `Order` VALUES (5003, 1003, '2024-01-25', 3003, 4003);

-- Insert OrderItems
INSERT INTO OrderItem VALUES (6001, 5001, 101, 2001, 1, 50000.00);
INSERT INTO OrderItem VALUES (6002, 5002, 102, 2002, 2, 500.00);
INSERT INTO OrderItem VALUES (6003, 5003, 103, 2001, 3, 300.00);
