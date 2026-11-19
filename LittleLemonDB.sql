-- 1. Create Database
CREATE DATABASE IF NOT EXISTS LittleLemonDB;
USE LittleLemonDB;
-- 2. Create Tables
CREATE TABLE Customers (
   CustomerID INT NOT NULL PRIMARY KEY,
   FullName VARCHAR(255) NOT NULL,
   ContactNumber VARCHAR(50) NOT NULL,
   Email VARCHAR(255) NOT NULL
);
CREATE TABLE Bookings (
   BookingID INT NOT NULL PRIMARY KEY,
   BookingDate DATE NOT NULL,
   TableNumber INT NOT NULL,
   CustomerID INT NOT NULL,
   FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE MenuItems (
   MenuItemsID INT NOT NULL PRIMARY KEY,
   CourseName VARCHAR(100),
   StarterName VARCHAR(100),
   DesertName VARCHAR(100)
);
CREATE TABLE Menus (
   MenuID INT NOT NULL PRIMARY KEY,
   MenuItemsID INT NOT NULL,
   MenuName VARCHAR(100),
   Cuisine VARCHAR(100),
   FOREIGN KEY (MenuItemsID) REFERENCES MenuItems(MenuItemsID)
);
CREATE TABLE Orders (
   OrderID INT NOT NULL PRIMARY KEY,
   OrderDate DATE NOT NULL,
   Quantity INT NOT NULL,
   TotalCost DECIMAL(10, 2) NOT NULL,
   BookingID INT,
   MenuID INT NOT NULL,
   CustomerID INT NOT NULL,
   FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
   FOREIGN KEY (MenuID) REFERENCES Menus(MenuID),
   FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDeliveryStatus (
   DeliveryID INT NOT NULL PRIMARY KEY,
   DeliveryDate DATE,
   Status VARCHAR(50) NOT NULL,
   OrderID INT NOT NULL,
   FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
-- 3. Insert Sample Data
INSERT INTO Customers VALUES
(1, 'Vanessa McCarthy', '0757536378', 'vanessa@example.com'),
(2, 'Marcos Romero', '0757536379', 'marcos@example.com'),
(3, 'Hiroki Yamane', '0757536376', 'hiroki@example.com');
INSERT INTO Bookings VALUES
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);
INSERT INTO MenuItems VALUES
(1, 'Greek Salad', 'Olives', 'Greek Yoghurt'),
(2, 'Bean Soup', 'Flatbread', 'Ice Cream'),
(3, 'Pizza', 'Minestrone', 'Cheesecake');
INSERT INTO Menus VALUES
(1, 1, 'Moussaka', 'Greek'),
(2, 2, 'Aperitivo', 'Italian'),
(3, 3, 'Manti', 'Turkish');
INSERT INTO Orders VALUES
(1, '2022-10-15', 5, 250.00, 1, 1, 1),
(2, '2022-10-16', 3, 180.00, 2, 2, 3),
(3, '2022-10-17', 2, 120.00, 3, 3, 2);
-- 4. Required Stored Procedures
-- Procedure 1: GetMaxQuantity()
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
   SELECT MAX(Quantity) AS 'Max Quantity in Order' FROM Orders;
END //
DELIMITER ;
-- Procedure 2: ManageBooking()
DELIMITER //
CREATE PROCEDURE ManageBooking(IN booking_date DATE, IN table_number INT)
BEGIN
   DECLARE table_status VARCHAR(50);
   SELECT IF(COUNT(*) > 0, CONCAT('Table ', table_number, ' is already booked'), CONCAT('Table ', table_number, ' is available'))
   INTO table_status
   FROM Bookings
   WHERE BookingDate = booking_date AND TableNumber = table_number;
   SELECT table_status AS 'Booking status';
END //
DELIMITER ;
-- Procedure 3: AddBooking()
DELIMITER //
CREATE PROCEDURE AddBooking(IN booking_id INT, IN customer_id INT, IN table_number INT, IN booking_date DATE)
BEGIN
   INSERT INTO Bookings (BookingID, CustomerID, TableNumber, BookingDate)
   VALUES (booking_id, customer_id, table_number, booking_date);
   SELECT 'New booking added' AS Confirmation;
END //
DELIMITER ;
-- Procedure 4: UpdateBooking()
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN booking_id INT, IN booking_date DATE)
BEGIN
   UPDATE Bookings
   SET BookingDate = booking_date
   WHERE BookingID = booking_id;
   SELECT CONCAT('Booking ', booking_id, ' updated') AS Confirmation;
END //
DELIMITER ;
-- Procedure 5: CancelBooking()
DELIMITER //
CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
   DELETE FROM Bookings
   WHERE BookingID = booking_id;
   SELECT CONCAT('Booking ', booking_id, ' cancelled') AS Confirmation;
END //
DELIMITER ;
