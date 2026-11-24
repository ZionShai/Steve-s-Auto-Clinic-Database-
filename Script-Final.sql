-- Create database
CREATE DATABASE SAC_DB;
GO

USE SAC_DB;
GO

-- TABLES

-- Customer
CREATE TABLE Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(255),
	DateRegistered DATE NOT NULL DEFAULT GETDATE()
);
GO

-- Vehicle
CREATE TABLE Vehicle (
    VehicleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    Make NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    Year INT NOT NULL,
	VIN NVARCHAR (50) NOT NULL DEFAULT '0',
	LicensePlate NVARCHAR (50) NOT NULL DEFAULT 'GP',
	Colour NVARCHAR (50) NOT NULL DEFAULT 'Black',
    RegistrationNumber NVARCHAR(20) UNIQUE NOT NULL,
    CONSTRAINT FK_Vehicle_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
GO

-- Employee
CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Position NVARCHAR(50),
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
	HireDate DATE NOT NULL DEFAULT GETDATE()
);
GO

-- Appointment
CREATE TABLE Appointment (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    VehicleID INT NOT NULL,
	CustomerID INT,
    AppointmentDate DATETIME NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Scheduled',
    EmployeeID INT NOT NULL,
	CONSTRAINT FK_Appointment_Customer FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
    CONSTRAINT FK_Appointment_Vehicle FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID),
    CONSTRAINT FK_Appointment_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
GO

-- Service
CREATE TABLE Service (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Cost DECIMAL(10,2) NOT NULL,
	DurationInMinutes INT NOT NULL DEFAULT 0
);
GO

-- Part
CREATE TABLE Part (
    PartID INT IDENTITY(1,1) PRIMARY KEY,
    PartName NVARCHAR(100) NOT NULL,
    PartNumber NVARCHAR(50) UNIQUE NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Quantity INT DEFAULT 0 
);
GO

-- ServiceDetail
CREATE TABLE ServiceRecord (
    ServiceRecordID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT NOT NULL,
    ServiceID INT NOT NULL,
	Notes NVARCHAR (50) NOT NULL DEFAULT 'None',
	LabourHours INT NOT NULL DEFAULT 0,
	ServiceFEE DECIMAL (10,2) NOT NULL DEFAULT 0,
    CONSTRAINT FK_ServiceDetail_Appointment FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID),
    CONSTRAINT FK_ServiceDetail_Service FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID)
);
GO

-- ServicePart
CREATE TABLE ServicePart (
    ServicePartID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceID INT NOT NULL,
    PartID INT NOT NULL,
    QuantityUsed INT DEFAULT 1,
	COST DECIMAL (10,2) NOT NULL DEFAULT 0,
    CONSTRAINT FK_ServicePart_Service FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),
    CONSTRAINT FK_ServicePart_Part FOREIGN KEY (PartID) REFERENCES Part(PartID)
);
GO

-- Invoices
CREATE TABLE Invoice (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT NOT NULL,
    IssueDate DATE NOT NULL DEFAULT GETDATE(),
	SubTotal DECIMAL (10,2) NOT NULL DEFAULT 0,
	TaxAmount DECIMAL (10,2) NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(10, 2) NOT NULL DEFAULT 0,
	InvoiceStatus NVARCHAR (50) NOT NULL DEFAULT 'Active',
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
)
go

-- Payments
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    InvoiceID INT NOT NULL,
    PaymentDate DATE NOT NULL DEFAULT GETDATE(),
    AmountPaid DECIMAL(10, 2) NOT NULL,
    PaymentMethod NVARCHAR(50) NOT NULL,
	ReferenceNumber INT NOT NULL DEFAULT 0,
    FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID)
);

-- Cancelled Appointments Log
CREATE TABLE CancelledAppointmentsLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT NOT NULL,
    CancelDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_CancelledAppointmentsLog_Appointment FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
);
GO

-- Sample Data

-- Services
INSERT INTO Service (ServiceName, Description, Cost, DurationInMinutes)
VALUES
('Engine Diagnostics', 'Full engine performance check', 850.00, 60),
('Oil Change', 'Replace oil and filter', 650.00, 30),
('Brake Inspection', 'Inspection and adjustment of brakes', 500.00, 45),
('Battery Replacement', 'Replace car battery', 1200.00, 40),
('Transmission Service', 'Check and service transmission system', 2000.00, 120),
('Suspension Check', 'Inspect suspension components', 900.00, 60),
('Wheel Alignment', 'Adjust the angles of wheels', 750.00, 50),
('Tyre Rotation', 'Rotate tyres for even wear', 300.00, 30),
('Aircon Regas', 'Recharge air conditioning system', 950.00, 45),
('Minor Service', 'Minor engine service including fluids check', 1100.00, 90);
GO

-- Parts
INSERT INTO Part (PartName, PartNumber, Price, Quantity)
VALUES
('Oil Filter', 'OF123', 150.00, 100),
('Spark Plug', 'SP456', 90.00, 200),
('Brake Pad Set', 'BP789', 600.00, 80),
('Battery 12V', 'BT101', 1400.00, 50),
('Transmission Fluid', 'TF202', 350.00, 120),
('Shock Absorber', 'SA303', 1200.00, 40),
('Wheel Alignment Kit', 'WA404', 950.00, 60),
('Tyre', 'TY505', 2000.00, 70),
('AC Gas Canister', 'AC606', 400.00, 90),
('Service Kit', 'SK707', 950.00, 30);
GO

-- Customers (50)
INSERT INTO Customer (FirstName, LastName, Email, Phone, Address)
VALUES
('John', 'Smith', 'john.smith01@example.com', '0811111101', '123 Main St'),
('Jane', 'Doe', 'jane.doe02@example.com', '0811111102', '456 Oak Rd'),
('Michael', 'Brown', 'michael.brown03@example.com', '0811111103', '789 Pine Ln'),
('Lisa', 'Johnson', 'lisa.johnson04@example.com', '0811111104', '321 Cedar Rd'),
('Chris', 'Miller', 'chris.miller05@example.com', '0811111105', '654 Birch Blvd'),
('Paul', 'Williams', 'paul.williams06@example.com', '0811111106', '213 Willow St'),
('Olivia', 'Jones', 'olivia.jones07@example.com', '0811111107', '987 Elm St'),
('Daniel', 'Taylor', 'daniel.taylor08@example.com', '0811111108', '741 Spruce St'),
('Emma', 'White', 'emma.white09@example.com', '0811111109', '369 Cherry Ave'),
('Luke', 'Lewis', 'luke.lewis10@example.com', '0811111110', '159 Ash Dr'),
('Ava', 'Harris', 'ava.harris11@example.com', '0811111111', '963 Beech Blvd'),
('Ethan', 'Martin', 'ethan.martin12@example.com', '0811111112', '753 Walnut Ct'),
('Sophia', 'Clark', 'sophia.clark13@example.com', '0811111113', '357 Cypress Rd'),
('Ryan', 'Allen', 'ryan.allen14@example.com', '0811111114', '951 Chestnut St'),
('Chloe', 'King', 'chloe.king15@example.com', '0811111115', '258 Fir St'),
('Jackson', 'Wright', 'jackson.wright16@example.com', '0811111116', '852 Poplar Rd'),
('Amelia', 'Lopez', 'amelia.lopez17@example.com', '0811111117', '456 Maple Cir'),
('Nathan', 'Scott', 'nathan.scott18@example.com', '0811111118', '654 Juniper Way'),
('Ella', 'Green', 'ella.green19@example.com', '0811111119', '147 Alder St'),
('David', 'Adams', 'david.adams20@example.com', '0811111120', '741 Dogwood Ln'),
('Lily', 'Baker', 'lily.baker21@example.com', '0811111121', '369 Redwood Rd'),
('Isaac', 'Gonzalez', 'isaac.gonzalez22@example.com', '0811111122', '159 Sequoia Ave'),
('Mia', 'Nelson', 'mia.nelson23@example.com', '0811111123', '963 Palm Blvd'),
('Sebastian', 'Carter', 'sebastian.carter24@example.com', '0811111124', '753 Olive St'),
('Sofia', 'Mitchell', 'sofia.mitchell25@example.com', '0811111125', '357 Hickory Ln'),
('Caleb', 'Perez', 'caleb.perez26@example.com', '0811111126', '951 Magnolia St'),
('Harper', 'Roberts', 'harper.roberts27@example.com', '0811111127', '258 Laurel St'),
('Julian', 'Turner', 'julian.turner28@example.com', '0811111128', '852 Cottonwood Rd'),
('Abigail', 'Phillips', 'abigail.phillips29@example.com', '0811111129', '456 Mulberry Cir'),
('Levi', 'Campbell', 'levi.campbell30@example.com', '0811111130', '654 Sycamore Way'),
('Victoria', 'Parker', 'victoria.parker31@example.com', '0811111131', '147 Maple St'),
('Gabriel', 'Evans', 'gabriel.evans32@example.com', '0811111132', '741 Cherry Ave'),
('Aria', 'Edwards', 'aria.edwards33@example.com', '0811111133', '369 Elm Ct'),
('Henry', 'Collins', 'henry.collins34@example.com', '0811111134', '159 Oak Dr'),
('Grace', 'Stewart', 'grace.stewart35@example.com', '0811111135', '963 Cedar Blvd'),
('Owen', 'Sanchez', 'owen.sanchez36@example.com', '0811111136', '753 Birch St'),
('Scarlett', 'Morris', 'scarlett.morris37@example.com', '0811111137', '357 Walnut Ln'),
('Matthew', 'Rogers', 'matthew.rogers38@example.com', '0811111138', '951 Pine St'),
('Zoey', 'Reed', 'zoey.reed39@example.com', '0811111139', '258 Willow Ave'),
('Wyatt', 'Cook', 'wyatt.cook40@example.com', '0811111140', '852 Beech Rd'),
('Hannah', 'Morgan', 'hannah.morgan41@example.com', '0811111141', '456 Spruce Cir'),
('Jack', 'Bell', 'jack.bell42@example.com', '0811111142', '654 Cypress Way'),
('Layla', 'Murphy', 'layla.murphy43@example.com', '0811111143', '147 Ash St'),
('Carter', 'Bailey', 'carter.bailey44@example.com', '0811111144', '741 Palm Blvd'),
('Victoria', 'Rivera', 'victoria.rivera45@example.com', '0811111145', '369 Chestnut Ct'),
('Dylan', 'Cooper', 'dylan.cooper46@example.com', '0811111146', '159 Sequoia Dr'),
('Penelope', 'Richardson', 'penelope.richardson47@example.com', '0811111147', '963 Dogwood Ave'),
('Luke', 'Cox', 'luke.cox48@example.com', '0811111148', '753 Juniper St'),
('Nora', 'Howard', 'nora.howard49@example.com', '0811111149', '357 Cedar Cir'),
('Elijah', 'Ward', 'elijah.ward50@example.com', '0811111150', '951 Maple Way');
GO
-- Vehicles
INSERT INTO Vehicle (CustomerID, Make, Model, Year, VIN, LicensePlate, Colour, RegistrationNumber)
VALUES
(1, 'Toyota', 'Hilux', 2020, 'VIN0001', 'CA12345', 'White', 'CA 12345'),
(2, 'Ford', 'Ranger', 2019, 'VIN0002', 'ND23456', 'Silver', 'ND 23456'),
(3, 'Volkswagen', 'Amarok', 2021, 'VIN0003', 'GP34567', 'Grey', 'GP 34567'),
(4, 'Isuzu', 'D-Max', 2022, 'VIN0004', 'EC45678', 'Red', 'EC 45678'),
(5, 'Nissan', 'Navara', 2018, 'VIN0005', 'L56789', 'Blue', 'L 56789'),
(6, 'Mazda', 'BT-50', 2022, 'VIN0006', 'CA11223', 'Black', 'CA 11223'),
(7, 'Chevrolet', 'Trailblazer', 2017, 'VIN0007', 'ND22334', 'White', 'ND 22334'),
(8, 'Mitsubishi', 'Pajero', 2019, 'VIN0008', 'GP33445', 'Grey', 'GP 33445'),
(9, 'Toyota', 'Fortuner', 2021, 'VIN0009', 'EC44556', 'Silver', 'EC 44556'),
(10, 'Ford', 'Everest', 2020, 'VIN0010', 'L55667', 'Black', 'L 55667'),
(11, 'Hyundai', 'Tucson', 2021, 'VIN0011', 'CA66778', 'Red', 'CA 66778'),
(12, 'Kia', 'Sportage', 2020, 'VIN0012', 'ND77889', 'White', 'ND 77889'),
(13, 'Honda', 'CR-V', 2019, 'VIN0013', 'GP88990', 'Silver', 'GP 88990'),
(14, 'Suzuki', 'Vitara', 2022, 'VIN0014', 'EC99001', 'Blue', 'EC 99001'),
(15, 'BMW', 'X3', 2020, 'VIN0015', 'L10112', 'Grey', 'L 10112'),
(16, 'Audi', 'Q5', 2021, 'VIN0016', 'CA21223', 'Black', 'CA 21223'),
(17, 'Mercedes', 'GLC', 2022, 'VIN0017', 'ND32334', 'White', 'ND 32334'),
(18, 'Jeep', 'Wrangler', 2020, 'VIN0018', 'GP43445', 'Red', 'GP 43445'),
(19, 'Renault', 'Duster', 2019, 'VIN0019', 'EC54556', 'Grey', 'EC 54556'),
(20, 'Peugeot', '3008', 2021, 'VIN0020', 'L65667', 'Silver', 'L 65667'),
(21, 'Land Rover', 'Discovery', 2022, 'VIN0021', 'CA76778', 'Green', 'CA 76778'),
(22, 'Subaru', 'Forester', 2020, 'VIN0022', 'ND87889', 'Blue', 'ND 87889'),
(23, 'Toyota', 'Corolla Cross', 2022, 'VIN0023', 'GP98990', 'White', 'GP 98990'),
(24, 'Ford', 'EcoSport', 2020, 'VIN0024', 'EC09001', 'Black', 'EC 09001'),
(25, 'Volkswagen', 'Tiguan', 2021, 'VIN0025', 'L10123', 'Red', 'L 10123'),
(26, 'Mazda', 'CX-5', 2020, 'VIN0026', 'CA21234', 'Silver', 'CA 21234'),
(27, 'Hyundai', 'Santa Fe', 2021, 'VIN0027', 'ND32345', 'Blue', 'ND 32345'),
(28, 'Kia', 'Seltos', 2020, 'VIN0028', 'GP43456', 'Grey', 'GP 43456'),
(29, 'Honda', 'HR-V', 2021, 'VIN0029', 'EC54567', 'White', 'EC 54567'),
(30, 'BMW', 'X5', 2020, 'VIN0030', 'L65678', 'Black', 'L 65678'),
(31, 'Audi', 'Q7', 2021, 'VIN0031', 'CA76789', 'Silver', 'CA 76789'),
(32, 'Mercedes', 'GLE', 2022, 'VIN0032', 'ND87890', 'Grey', 'ND 87890'),
(33, 'Jeep', 'Grand Cherokee', 2020, 'VIN0033', 'GP98901', 'White', 'GP 98901'),
(34, 'Renault', 'Koleos', 2021, 'VIN0034', 'EC09012', 'Blue', 'EC 09012'),
(35, 'Peugeot', '5008', 2022, 'VIN0035', 'L10134', 'Black', 'L 10134'),
(36, 'Land Rover', 'Defender', 2020, 'VIN0036', 'CA21245', 'Green', 'CA 21245'),
(37, 'Subaru', 'Outback', 2021, 'VIN0037', 'ND32356', 'Silver', 'ND 32356'),
(38, 'Toyota', 'Rav4', 2022, 'VIN0038', 'GP43467', 'Red', 'GP 43467'),
(39, 'Ford', 'Kuga', 2020, 'VIN0039', 'EC54578', 'White', 'EC 54578'),
(40, 'Volkswagen', 'Touareg', 2021, 'VIN0040', 'L65689', 'Black', 'L 65689'),
(41, 'Mazda', 'CX-9', 2020, 'VIN0041', 'CA76790', 'Blue', 'CA 76790'),
(42, 'Hyundai', 'Palisade', 2021, 'VIN0042', 'ND87801', 'Grey', 'ND 87801'),
(43, 'Kia', 'Sorento', 2020, 'VIN0043', 'GP98912', 'Silver', 'GP 98912'),
(44, 'Honda', 'Passport', 2021, 'VIN0044', 'EC09023', 'White', 'EC 09023'),
(45, 'BMW', 'X1', 2020, 'VIN0045', 'L10145', 'Red', 'L 10145'),
(46, 'Audi', 'Q3', 2021, 'VIN0046', 'CA21256', 'Black', 'CA 21256'),
(47, 'Mercedes', 'GLA', 2022, 'VIN0047', 'ND32367', 'Blue', 'ND 32367'),
(48, 'Jeep', 'Compass', 2020, 'VIN0048', 'GP43478', 'Grey', 'GP 43478'),
(49, 'Renault', 'Captur', 2021, 'VIN0049', 'EC54589', 'Silver', 'EC 54589'),
(50, 'Peugeot', '2008', 2022, 'VIN0050', 'L65690', 'White', 'L 65690');
GO
-- Employees
INSERT INTO Employee (FirstName, LastName, Position, Email, Phone)
VALUES
('Mike', 'Jordan', 'Mechanic', 'mike.jordan@sac.co.za', '0731112222'),
('Sarah', 'Connor', 'Receptionist', 'sarah.connor@sac.co.za', '0743334444'),
('David', 'Clark', 'Technician', 'david.clark@sac.co.za', '0754445555'),
('Angela', 'Young', 'Manager', 'angela.young@sac.co.za', '0765556666'),
('Ethan', 'Hunt', 'Mechanic', 'ethan.hunt@sac.co.za', '0776667777'),
('Olivia', 'Moore', 'Admin Assistant', 'olivia.moore@sac.co.za', '0787778888'),
('Daniel', 'Scott', 'Technician', 'daniel.scott@sac.co.za', '0798889999'),
('Sophia', 'Green', 'Receptionist', 'sophia.green@sac.co.za', '0709990000'),
('Anthony', 'Baker', 'Service Advisor', 'anthony.baker@sac.co.za', '0710001111'),
('Grace', 'Nelson', 'Customer Service', 'grace.nelson@sac.co.za', '0721112222'),
('Liam', 'Gray', 'Mechanic', 'liam.gray@sac.co.za', '0732223333'),
('Zoe', 'Knight', 'Technician', 'zoe.knight@sac.co.za', '0743334445'),
('Noah', 'Brooks', 'Admin', 'noah.brooks@sac.co.za', '0754445556'),
('Emma', 'Foster', 'Receptionist', 'emma.foster@sac.co.za', '0765556667'),
('Lucas', 'Bennett', 'Technician', 'lucas.bennett@sac.co.za', '0776667778');
GO
-- Appointments
INSERT INTO Appointment (VehicleID, CustomerID, AppointmentDate, Status, EmployeeID)
VALUES
(1, 1, '2025-04-20', 'Scheduled', 1),
(2, 2, '2025-04-21', 'Scheduled', 2),
(3, 3, '2025-04-22', 'Scheduled', 3),
(4, 4, '2025-04-23', 'Scheduled', 4),
(5, 5, '2025-04-24', 'Scheduled', 5),
(6, 6, '2025-04-25', 'Scheduled', 6),
(7, 7, '2025-04-26', 'Scheduled', 7),
(8, 8, '2025-04-27', 'Scheduled', 8),
(9, 9, '2025-04-28', 'Scheduled', 9),
(10, 10, '2025-04-29', 'Scheduled', 10),
(11, 11, '2025-04-30', 'Scheduled', 11),
(12, 12, '2025-05-01', 'Scheduled', 12),
(13, 13, '2025-05-02', 'Scheduled', 13),
(14, 14, '2025-05-03', 'Scheduled', 14),
(15, 15, '2025-05-04', 'Scheduled', 15),
(16, 16, '2025-05-05', 'Scheduled', 1),
(17, 17, '2025-05-06', 'Scheduled', 2),
(18, 18, '2025-05-07', 'Scheduled', 3),
(19, 19, '2025-05-08', 'Scheduled', 4),
(20, 20, '2025-05-09', 'Scheduled', 5),
(21, 21, '2025-05-10', 'Scheduled', 6),
(22, 22, '2025-05-11', 'Scheduled', 7),
(23, 23, '2025-05-12', 'Scheduled', 8),
(24, 24, '2025-05-13', 'Scheduled', 9),
(25, 25, '2025-05-14', 'Scheduled', 10),
(26, 26, '2025-05-15', 'Scheduled', 11),
(27, 27, '2025-05-16', 'Scheduled', 12),
(28, 28, '2025-05-17', 'Scheduled', 13),
(29, 29, '2025-05-18', 'Scheduled', 14),
(30, 30, '2025-05-19', 'Scheduled', 15),
(31, 31, '2025-05-20', 'Scheduled', 1),
(32, 32, '2025-05-21', 'Scheduled', 2),
(33, 33, '2025-05-22', 'Scheduled', 3),
(34, 34, '2025-05-23', 'Scheduled', 4),
(35, 35, '2025-05-24', 'Scheduled', 5),
(36, 36, '2025-05-25', 'Scheduled', 6),
(37, 37, '2025-05-26', 'Scheduled', 7),
(38, 38, '2025-05-27', 'Scheduled', 8),
(39, 39, '2025-05-28', 'Scheduled', 9),
(40, 40, '2025-05-29', 'Scheduled', 10),
(41, 41, '2025-05-30', 'Scheduled', 11),
(42, 42, '2025-05-31', 'Scheduled', 12),
(43, 43, '2025-06-01', 'Scheduled', 13),
(44, 44, '2025-06-02', 'Scheduled', 14),
(45, 45, '2025-06-03', 'Scheduled', 15),
(46, 46, '2025-06-04', 'Scheduled', 1),
(47, 47, '2025-06-05', 'Scheduled', 2),
(48, 48, '2025-06-06', 'Scheduled', 3),
(49, 49, '2025-06-07', 'Scheduled', 4),
(50, 50, '2025-06-08', 'Scheduled', 5);
GO
-- ServiceRecords
INSERT INTO ServiceRecord(AppointmentID, ServiceID, Notes, LabourHours, ServiceFEE)
VALUES
(1, 1, 'Completed', 2, 1150.00),
(2, 2, 'Completed', 1, 800.00),
(3, 3, 'Completed', 1, 650.00),
(4, 4, 'Completed', 2, 1500.00),
(5, 5, 'In Progress', 3, 2450.00),
(6, 6, 'Completed', 1, 1050.00),
(7, 7, 'Completed', 1, 900.00),
(8, 8, 'Pending', 1, 450.00),
(9, 9, 'Completed', 1, 1100.00),
(10, 10, 'Completed', 2, 1400.00),
(11, 1, 'None', 2, 1150.00),
(12, 2, 'Completed', 1, 800.00),
(13, 3, 'In Progress', 1, 650.00),
(14, 4, 'Completed', 2, 1500.00),
(15, 5, 'Completed', 3, 2450.00),
(16, 6, 'Completed', 1, 1050.00),
(17, 7, 'Completed', 1, 900.00),
(18, 8, 'None', 1, 450.00),
(19, 9, 'Completed', 1, 1100.00),
(20, 10, 'Completed', 2, 1400.00),
(21, 1, 'Completed', 2, 1150.00),
(22, 2, 'Completed', 1, 800.00),
(23, 3, 'Completed', 1, 650.00),
(24, 4, 'Completed', 2, 1500.00),
(25, 5, 'Completed', 3, 2450.00),
(26, 6, 'Completed', 1, 1050.00),
(27, 7, 'Completed', 1, 900.00),
(28, 8, 'Completed', 1, 450.00),
(29, 9, 'Completed', 1, 1100.00),
(30, 10, 'Completed', 2, 1400.00),
(31, 1, 'None', 2, 1150.00),
(32, 2, 'In Progress', 1, 800.00),
(33, 3, 'Completed', 1, 650.00),
(34, 4, 'Pending', 2, 1500.00),
(35, 5, 'Completed', 3, 2450.00),
(36, 6, 'Completed', 1, 1050.00),
(37, 7, 'Completed', 1, 900.00),
(38, 8, 'Completed', 1, 450.00),
(39, 9, 'Completed', 1, 1100.00),
(40, 10, 'Completed', 2, 1400.00),
(41, 1, 'Completed', 2, 1150.00),
(42, 2, 'Completed', 1, 800.00),
(43, 3, 'Completed', 1, 650.00),
(44, 4, 'Completed', 2, 1500.00),
(45, 5, 'Completed', 3, 2450.00),
(46, 6, 'Completed', 1, 1050.00),
(47, 7, 'Completed', 1, 900.00),
(48, 8, 'None', 1, 450.00),
(49, 9, 'Completed', 1, 1100.00),
(50, 10, 'Completed', 2, 1400.00);
GO
-- Serviceparts
INSERT INTO ServicePart (ServiceID, PartID, QuantityUsed, Cost)
VALUES
(1, 1, 1, 150.00),
(2, 2, 4, 320.00),
(3, 3, 2, 240.00),
(4, 4, 1, 950.00),
(5, 5, 3, 900.00),
(6, 6, 2, 1200.00),
(7, 7, 1, 350.00),
(8, 8, 4, 800.00),
(9, 9, 1, 450.00),
(10, 10, 5, 500.00),
(1, 2, 1, 80.00),
(2, 3, 2, 240.00),
(3, 4, 1, 950.00),
(4, 5, 3, 900.00),
(5, 6, 2, 1200.00),
(6, 7, 1, 350.00),
(7, 8, 4, 800.00),
(8, 9, 2, 900.00),
(9, 10, 1, 100.00),
(10, 1, 3, 450.00),
(1, 3, 1, 120.00),
(2, 4, 2, 1900.00),
(3, 5, 1, 300.00),
(4, 6, 2, 1200.00),
(5, 7, 2, 700.00),
(6, 8, 1, 200.00),
(7, 9, 2, 900.00),
(8, 10, 1, 100.00),
(9, 1, 3, 450.00),
(10, 2, 1, 80.00),
(1, 4, 1, 950.00),
(2, 5, 2, 600.00),
(3, 6, 1, 600.00),
(4, 7, 3, 1050.00),
(5, 8, 2, 400.00),
(6, 9, 1, 450.00),
(7, 10, 4, 400.00),
(8, 1, 2, 300.00),
(9, 2, 1, 80.00),
(10, 3, 3, 360.00),
(1, 5, 1, 300.00),
(2, 6, 2, 1200.00),
(3, 7, 1, 350.00),
(4, 8, 3, 600.00),
(5, 9, 2, 900.00),
(6, 10, 1, 100.00),
(7, 1, 2, 300.00),
(8, 2, 1, 80.00),
(9, 3, 3, 360.00),
(10, 4, 1, 950.00);
GO
-- Insert into invoice
INSERT INTO Invoice (AppointmentID, IssueDate, SubTotal, TaxAmount, TotalAmount, InvoiceStatus)
VALUES
(1, '2025-04-20', 850.00, 127.50, 977.50, 'Active'),
(2, '2025-04-21', 900.00, 135.00, 1035.00, 'Active'),
(3, '2025-04-22', 950.00, 142.50, 1092.50, 'Active'),
(4, '2025-04-23', 1000.00, 150.00, 1150.00, 'Active'),
(5, '2025-04-24', 1050.00, 157.50, 1207.50, 'Active'),
(6, '2025-04-25', 1100.00, 165.00, 1265.00, 'Active'),
(7, '2025-04-26', 1150.00, 172.50, 1322.50, 'Active'),
(8, '2025-04-27', 1200.00, 180.00, 1380.00, 'Active'),
(9, '2025-04-28', 1250.00, 187.50, 1437.50, 'Active'),
(10, '2025-04-29', 1300.00, 195.00, 1495.00, 'Active'),
(11, '2025-04-30', 1350.00, 202.50, 1552.50, 'Active'),
(12, '2025-05-01', 1400.00, 210.00, 1610.00, 'Active'),
(13, '2025-05-02', 1450.00, 217.50, 1667.50, 'Active'),
(14, '2025-05-03', 1500.00, 225.00, 1725.00, 'Active'),
(15, '2025-05-04', 1550.00, 232.50, 1782.50, 'Active'),
(16, '2025-05-05', 1600.00, 240.00, 1840.00, 'Active'),
(17, '2025-05-06', 1650.00, 247.50, 1897.50, 'Active'),
(18, '2025-05-07', 1700.00, 255.00, 1955.00, 'Active'),
(19, '2025-05-08', 1750.00, 262.50, 2012.50, 'Active'),
(20, '2025-05-09', 1800.00, 270.00, 2070.00, 'Active'),
(21, '2025-05-10', 1850.00, 277.50, 2127.50, 'Active'),
(22, '2025-05-11', 1900.00, 285.00, 2185.00, 'Active'),
(23, '2025-05-12', 1950.00, 292.50, 2242.50, 'Active'),
(24, '2025-05-13', 2000.00, 300.00, 2300.00, 'Active'),
(25, '2025-05-14', 850.00, 127.50, 977.50, 'Active'),
(26, '2025-05-15', 900.00, 135.00, 1035.00, 'Active'),
(27, '2025-05-16', 950.00, 142.50, 1092.50, 'Active'),
(28, '2025-05-17', 1000.00, 150.00, 1150.00, 'Active'),
(29, '2025-05-18', 1050.00, 157.50, 1207.50, 'Active'),
(30, '2025-05-19', 1100.00, 165.00, 1265.00, 'Active'),
(31, '2025-05-20', 1150.00, 172.50, 1322.50, 'Active'),
(32, '2025-05-21', 1200.00, 180.00, 1380.00, 'Active'),
(33, '2025-05-22', 1250.00, 187.50, 1437.50, 'Active'),
(34, '2025-05-23', 1300.00, 195.00, 1495.00, 'Active'),
(35, '2025-05-24', 1350.00, 202.50, 1552.50, 'Active'),
(36, '2025-05-25', 1400.00, 210.00, 1610.00, 'Active'),
(37, '2025-05-26', 1450.00, 217.50, 1667.50, 'Active'),
(38, '2025-05-27', 1500.00, 225.00, 1725.00, 'Active'),
(39, '2025-05-28', 1550.00, 232.50, 1782.50, 'Active'),
(40, '2025-05-29', 1600.00, 240.00, 1840.00, 'Active'),
(41, '2025-05-30', 1650.00, 247.50, 1897.50, 'Active'),
(42, '2025-05-31', 1700.00, 255.00, 1955.00, 'Active'),
(43, '2025-06-01', 1750.00, 262.50, 2012.50, 'Active'),
(44, '2025-06-02', 1800.00, 270.00, 2070.00, 'Active'),
(45, '2025-06-03', 1850.00, 277.50, 2127.50, 'Active'),
(46, '2025-06-04', 1900.00, 285.00, 2185.00, 'Active'),
(47, '2025-06-05', 1950.00, 292.50, 2242.50, 'Active'),
(48, '2025-06-06', 2000.00, 300.00, 2300.00, 'Active'),
(49, '2025-06-07', 850.00, 127.50, 977.50, 'Active'),
(50, '2025-06-08', 900.00, 135.00, 1035.00, 'Active');
GO

-- Insert into payment
INSERT INTO Payment (InvoiceID, PaymentDate, AmountPaid, PaymentMethod, ReferenceNumber)
VALUES
(1, '2025-04-20', 977.50, 'Card', 10001),
(2, '2025-04-21', 1035.00, 'Cash', 10002),
(3, '2025-04-22', 1092.50, 'EFT', 10003),
(4, '2025-04-23', 1150.00, 'Card', 10004),
(5, '2025-04-24', 1207.50, 'Cash', 10005),
(6, '2025-04-25', 1265.00, 'Card', 10006),
(7, '2025-04-26', 1322.50, 'EFT', 10007),
(8, '2025-04-27', 1380.00, 'Card', 10008),
(9, '2025-04-28', 1437.50, 'Cash', 10009),
(10, '2025-04-29', 1495.00, 'Card', 10010),
(11, '2025-04-30', 1552.50, 'Card', 10011),
(12, '2025-05-01', 1610.00, 'Cash', 10012),
(13, '2025-05-02', 1667.50, 'Card', 10013),
(14, '2025-05-03', 1725.00, 'Card', 10014),
(15, '2025-05-04', 1782.50, 'Cash', 10015),
(16, '2025-05-05', 1840.00, 'EFT', 10016),
(17, '2025-05-06', 1897.50, 'Card', 10017),
(18, '2025-05-07', 1955.00, 'Cash', 10018),
(19, '2025-05-08', 2012.50, 'Card', 10019),
(20, '2025-05-09', 2070.00, 'EFT', 10020),
(21, '2025-05-10', 2127.50, 'Card', 10021),
(22, '2025-05-11', 2185.00, 'Cash', 10022),
(23, '2025-05-12', 2242.50, 'Card', 10023),
(24, '2025-05-13', 2300.00, 'EFT', 10024),
(25, '2025-05-14', 977.50, 'Card', 10025),
(26, '2025-05-15', 1035.00, 'Cash', 10026),
(27, '2025-05-16', 1092.50, 'Card', 10027),
(28, '2025-05-17', 1150.00, 'EFT', 10028),
(29, '2025-05-18', 1207.50, 'Card', 10029),
(30, '2025-05-19', 1265.00, 'Cash', 10030),
(31, '2025-05-20', 1322.50, 'EFT', 10031),
(32, '2025-05-21', 1380.00, 'Card', 10032),
(33, '2025-05-22', 1437.50, 'Card', 10033),
(34, '2025-05-23', 1495.00, 'Cash', 10034),
(35, '2025-05-24', 1552.50, 'Card', 10035),
(36, '2025-05-25', 1610.00, 'EFT', 10036),
(37, '2025-05-26', 1667.50, 'Cash', 10037),
(38, '2025-05-27', 1725.00, 'Card', 10038),
(39, '2025-05-28', 1782.50, 'EFT', 10039),
(40, '2025-05-29', 1840.00, 'Cash', 10040),
(41, '2025-05-30', 1897.50, 'Card', 10041),
(42, '2025-05-31', 1955.00, 'Cash', 10042),
(43, '2025-06-01', 2012.50, 'EFT', 10043),
(44, '2025-06-02', 2070.00, 'Card', 10044),
(45, '2025-06-03', 2127.50, 'Cash', 10045),
(46, '2025-06-04', 2185.00, 'EFT', 10046),
(47, '2025-06-05', 2242.50, 'Card', 10047),
(48, '2025-06-06', 2300.00, 'Cash', 10048),
(49, '2025-06-07', 977.50, 'Card', 10049),
(50, '2025-06-08', 1035.00, 'EFT', 10050);
GO

-- VIEWS

-- Active Appointments
CREATE VIEW vw_ActiveAppointments AS
SELECT
    A.AppointmentID,
    C.FirstName + ' ' + C.LastName AS CustomerName,
    V.Make + ' ' + V.Model AS Vehicle,
    A.AppointmentDate,
    A.Status
FROM Appointment A
INNER JOIN Vehicle V ON A.VehicleID = V.VehicleID
INNER JOIN Customer C ON V.CustomerID = C.CustomerID
WHERE A.Status = 'Scheduled';
GO

-- Customer Appointments View
CREATE VIEW CustomerAppointmentsView AS
SELECT
    C.FirstName,
    C.LastName,
    V.Make,
    V.Model,
    A.AppointmentDate,
    A.Status
FROM Customer C
JOIN Vehicle V ON C.CustomerID = V.CustomerID
JOIN Appointment A ON V.VehicleID = A.VehicleID;
GO

-- Employee Service Summary
CREATE VIEW EmployeeServiceSummaryView AS
SELECT
    E.FirstName,
    E.LastName,
    COUNT(SR.ServiceID) AS ServiceCount
FROM Employee E
JOIN Appointment A ON E.EmployeeID = A.EmployeeID
JOIN ServiceRecord SR ON A.AppointmentID = SR.AppointmentID
GROUP BY E.FirstName, E.LastName;
GO

-- Part Usage View
CREATE VIEW PartUsageView AS
SELECT
    S.ServiceName,
    P.PartName,
    SP.QuantityUsed
FROM Service S
JOIN ServicePart SP ON S.ServiceID = SP.ServiceID
JOIN Part P ON SP.PartID = P.PartID;
GO

-- Appointment Detail View
CREATE VIEW AppointmentDetailView AS
SELECT
    A.AppointmentID,
    C.FirstName,
    C.LastName,
    V.Make,
    V.Model,
    S.ServiceName,
    E.FirstName AS Employee
FROM Appointment A
JOIN Vehicle V ON A.VehicleID = V.VehicleID
JOIN Customer C ON V.CustomerID = C.CustomerID
JOIN Employee E ON A.EmployeeID = E.EmployeeID
JOIN ServiceRecord SR ON A.AppointmentID = SR.AppointmentID
JOIN Service S ON SR.ServiceID = S.ServiceID;
GO
-- STORED PROCEDURES

-- Assign Service to Appointment
CREATE PROCEDURE AssignService
    @AppointmentID INT,
    @ServiceID INT
AS
BEGIN
    INSERT INTO ServiceRecord(AppointmentID, ServiceID)
    VALUES (@AppointmentID, @ServiceID);
END;
GO

-- Book Appointment
CREATE PROCEDURE sp_BookAppointment
    @CustomerID INT,
    @VehicleID INT,
    @EmployeeID INT,
    @Date DATE
AS
BEGIN
    INSERT INTO Appointment (VehicleID, AppointmentDate, Status, EmployeeID)
    VALUES (@VehicleID, @Date, 'Scheduled', @EmployeeID);
END;
GO

-- Record Service Completion
CREATE PROCEDURE sp_RecordServiceCompletion
    @AppointmentID INT
AS
BEGIN
    UPDATE Appointment
    SET Status = 'Completed'
    WHERE AppointmentID = @AppointmentID;
END;
GO

-- Generate Monthly Report
CREATE PROCEDURE sp_GenerateMonthlyReport
    @Month INT,
    @Year INT
AS
BEGIN
    SELECT
        A.AppointmentID,
        C.FirstName,
        C.LastName,
        S.ServiceName,
        A.AppointmentDate
    FROM Appointment A
    JOIN Vehicle V ON A.VehicleID = V.VehicleID
    JOIN Customer C ON V.CustomerID = C.CustomerID
    JOIN ServiceRecord SR ON A.AppointmentID = SR.AppointmentID
    JOIN Service S ON SR.ServiceID = S.ServiceID
    WHERE MONTH(A.AppointmentDate) = @Month
    AND YEAR(A.AppointmentDate) = @Year;
END;
GO
-- TRIGGERS

-- After Service Completed
CREATE TRIGGER trg_UpdateStatusAfterCompletion
ON ServiceRecord
AFTER INSERT
AS
BEGIN
    UPDATE A
    SET Status = 'Completed'
    FROM Appointment A
    WHERE A.AppointmentID IN (SELECT DISTINCT AppointmentID FROM inserted);
END;
GO

-- Update Inventory after Service
CREATE TRIGGER tr_UpdateInventoryAfterService
ON ServicePart
AFTER INSERT
AS
BEGIN
    UPDATE P
    SET Quantity = Quantity - I.QuantityUsed
    FROM Part P
    JOIN inserted I ON P.PartID = I.PartID;
END;
GO

-- Log Appointment Cancellation
CREATE TRIGGER tr_LogAppointmentCancellation
ON Appointment
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Status = 'Cancelled')
    BEGIN
        INSERT INTO CancelledAppointmentsLog (AppointmentID)
        SELECT AppointmentID FROM inserted WHERE Status = 'Cancelled';
    END
END;
GO
-- USER CREATION

-- Create Login and User
CREATE LOGIN SAC_Staff WITH PASSWORD = 'SACpassword123!';
CREATE USER SAC_User FOR LOGIN SAC_Staff;
GO

-- Permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON Customer TO SAC_User;
GRANT SELECT, INSERT ON Appointment TO SAC_User;
GRANT SELECT ON vw_ActiveAppointments TO SAC_User;
GO