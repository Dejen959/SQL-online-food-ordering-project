-- ============================================================
-- Online Food Ordering System — SQL Implementation
-- Addis Ababa Science and Technology University
-- Database Systems Course Project, 2025/2026 Academic Year
-- ============================================================
USE master;
CREATE DATABASE FoodOrderingDB;
USE FoodOrderingDB;
----------------------------------------
--Table 1: Admins
----------------------------------------
CREATE TABLE admins (
    adminID INT PRIMARY KEY NOT NULL,
    firstName NVARCHAR(25) NOT NULL,
    lastName NVARCHAR(25) NOT NULL,
    email VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(15) NOT NULL,
    role VARCHAR(50) NOT NULL
);

--Table of restaurant information
CREATE TABLE restaurants (
    restaurantID INT PRIMARY KEY NOT NULL,
    restaurantName NVARCHAR(25) NOT NULL,
    adminID INT NOT NULL,
    subCity NVARCHAR(50) NOT NULL,
    wereda NVARCHAR(50) NOT NULL,
    street NVARCHAR(50) NOT NULL,
    openingTime TIME NOT NULL,
    closingTime TIME NOT NULL,
    CONSTRAINT restaurants_admin_fk FOREIGN KEY (adminID) 
    REFERENCES admins(adminID)
);

--Table of restaurant owner contact information
CREATE TABLE restOwnerContacts (
    ownerID VARCHAR(10) PRIMARY KEY NOT NULL,
    ownerContactNumber NVARCHAR(15) NOT NULL
);

--Table of restaurant owners
    CREATE TABLE restOwners(
    ownerID INT PRIMARY KEY NOT NULL,
    firstName NVARCHAR(25) NOT NULL,
    lastName NVARCHAR(25) NOT NULL,
    email VARCHAR(30) NOT NULL UNIQUE,
    restaurantID INT NOT NULL,
    CONSTRAINT fk_restOwners_restaurants FOREIGN KEY (restaurantID) 
    REFERENCES restaurants(restaurantID)
);



--Table of customer badges for loyalty program
CREATE TABLE customerBadges (
    badgeID INT PRIMARY KEY NOT NULL,
    badgeName VARCHAR(50) NOT NULL,
    minimumOrders INT NOT NULL,
    awardDate DATE NOT NULL DEFAULT GETDATE() 
);

--Table of categories for menu items
CREATE TABLE categories(
    categoryID INT PRIMARY KEY NOT NULL,
    categoryName NVARCHAR(25) NOT NULL,
    parentCategoryID INT
);

--Table of menu items offered by restaurants
CREATE TABLE menuItems (
    menuItemID INT PRIMARY KEY NOT NULL,
    menuItemName NVARCHAR(50) NOT NULL,
    restaurantID INT NOT NULL,
    categoryID INT,
    menuItemPrice DECIMAL(10, 2) NOT NULL,
    availabilityStatus NVARCHAR(20) NOT NULL,
    CONSTRAINT restaurantId_fk FOREIGN KEY (restaurantID) 
    REFERENCES restaurants(restaurantID),
    CONSTRAINT categoryId_fk FOREIGN KEY (categoryID)
    REFERENCES categories(categoryID)
);

--Table of customers who use the ordering system
CREATE TABLE customers (
    customerID INT PRIMARY KEY NOT NULL,
    badgeID INT,
    firstName NVARCHAR(25) NOT NULL,
    lastName NVARCHAR(25) NOT NULL,
    email VARCHAR(30) UNIQUE,
    subCity NVARCHAR(50) NOT NULL,
    wereda NVARCHAR(50) NOT NULL,
    street NVARCHAR(50) NOT NULL,
    regDate DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_badgeID FOREIGN KEY (badgeID) 
    REFERENCES customerBadges(badgeID)
);
CREATE TABLE customersPhone (
    phoneID INT PRIMARY KEY NOT NULL,
    customerID INT NOT NULL,
    phoneNumber VARCHAR(15) NOT NULL
);

--Table of orders placed by customers
CREATE TABLE orders(
    orderID INT PRIMARY KEY NOT NULL,
    customerID INT  NOT NULL,
    orderDate DATE DEFAULT GETDATE() NOT NULL,
    totalAmount DECIMAL(10, 2) NOT NULL,
    orderStatus NVARCHAR(50) NOT NULL,
    CONSTRAINT fk_customerID FOREIGN KEY (customerID) 
    REFERENCES customers(customerID)
);

--Table of items included in each order
CREATE TABLE orderItems (
    orderID INT NOT NULL,
    menuItemID INT NOT NULL,
    quantity INT NOT NULL,
    orderItemPrice DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_orderId FOREIGN KEY (orderID) 
    REFERENCES orders(orderID),
    CONSTRAINT fk_menuItemId FOREIGN KEY (menuItemID) 
    REFERENCES menuItems(menuItemID)
);

--Table of reviews to the restaurants by customers
CREATE TABLE reviews(
    reviewID INT PRIMARY KEY NOT NULL,
    restaurantID INT NOT NULL,
    customerID INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(255) NOT NULL,
    reviewDate DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_restaurant
        FOREIGN KEY (restaurantID)
        REFERENCES restaurants(restaurantID)
        ON DELETE CASCADE,
    CONSTRAINT fk_customer
        FOREIGN KEY (customerID)
        REFERENCES customers(customerID)
        ON DELETE CASCADE
);

--Table of payments for orders
CREATE TABLE payments(
    paymentID INT PRIMARY KEY,
    orderID INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    paymentStatus NVARCHAR(25) NOT NULL,
    transactionID VARCHAR(50) NOT NULL,
    paymentDate   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paymentMethod NVARCHAR(25) NOT NULL,
    CONSTRAINT fk_order
        FOREIGN KEY (orderID) 
        REFERENCES orders(orderID)
        ON DELETE CASCADE
);

--Table of drivers who deliver the orders:
CREATE TABLE drivers(
    driverID INT PRIMARY KEY,
    firstName NVARCHAR(15) NOT NULL,
    lastName NVARCHAR(15) NOT NULL,
    email VARCHAR(30) NOT NULL,
    vehicleNumber VARCHAR(15) NOT NULL,
    availabilityStatus NVARCHAR(10) NOT NULL,
    joinDate DATE NOT NULL DEFAULT GETDATE()
);
--Table of deliveries made by drivers for orders
CREATE TABLE deliveries(
    deliveryID INT PRIMARY KEY,
    orderID INT NOT NULL,
    driverID INT NOT NULL,
    deliveryStatus NVARCHAR(50) NOT NULL,
    startTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    endTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deliveryDate DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_driver
        FOREIGN KEY (driverID)
        REFERENCES drivers(driverID),
    CONSTRAINT fk_order
        FOREIGN KEY (orderID)
        REFERENCES orders(orderID)
        ON DELETE CASCADE
);
