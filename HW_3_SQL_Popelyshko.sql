CREATE DATABASE ThirdDB
ON
(
	NAME='ThirdDB',
	FILENAME = 'D:\ThirdDB.mdf',
	SIZE=200MB,
	MAXSIZE=2000MB,
	FILEGROWTH=10MB
)
LOG ON
(
	NAME = 'LogThirdDB',
	FILENAME = 'D:\ThirdDB.ldf',
	SIZE=100MB,
	MAXSIZE=1000MB,
	FILEGROWTH=10MB
)
COLLATE Cyrillic_General_CI_AS

EXECUTE sp_helpdb ThirdDB;

USE ThirdDB
GO
--Drops are down below
CREATE TABLE Clients
(
	ClientId int IDENTITY NOT NULL
	PRIMARY KEY,
	ClientName Varchar(20) NOT NULL,
	Email Varchar(20),
	Gender Varchar(6) NOT NULL,
	IsRegular Varchar(10) NOT NULL,
)
GO

CREATE TABLE Hotels
(
	HotelId int IDENTITY NOT NULL
	PRIMARY KEY,
	HotelName Varchar(20) NOT NULL,
	StarsCount int NOT NULL,
	CreationYear int NOT NULL,
	Adress Varchar(20),
	IsActive Varchar(20) NOT NULL,
	AvaliableRoomsCount int NOT NULL,
	SeasonalDiscount int NOT NULL,
	RegularDiscount int NOT NULL
)

CREATE TABLE Rooms
(
	RoomId int IDENTITY NOT NULL
	PRIMARY KEY,
	RoomNumber int NOT NULL,
	ÑomfortLevel int NOT NULL,
	Capability int NOT NULL,
	HotelId int NOT NULL
	FOREIGN KEY REFERENCES Hotels(HotelId),
	Price int NOT NULL,
)


CREATE TABLE Reservations
(
	ReservationId int IDENTITY NOT NULL
	PRIMARY KEY,
	ReservationDate Date NOT NULL,
	ClientId int NOT NULL
	FOREIGN KEY REFERENCES Clients(ClientId),
	RoomId int NOT NULL 
	FOREIGN KEY REFERENCES Rooms(RoomId),
	StartDay Date NOT NULL,
	EndDate Date NOT NULL,
	Breakfast Varchar(10) NOT NULL,
	Gym Varchar(10) NOT NULL,
	SwimPool Varchar(10) NOT NULL
)
GO

INSERT INTO Hotels (HotelName, StarsCount, CreationYear, Adress, IsActive, AvaliableRoomsCount, SeasonalDiscount, RegularDiscount) VALUES
('Edelweiss', '5', '2005', 'Ulica Myra', 'true', '30', '5', '5'),
('Bucovina', '4', '2000', 'Holovna', 'true', '60', '5','10'),
('Cheremosh', '3', '2010', 'Heroiv Maidanu', 'false', '65', '5', '5')

SELECT * FROM Hotels

UPDATE Hotels
SET CreationYear ='1937'
WHERE HotelId='1'

DELETE FROM Hotels
WHERE HotelId='3'

INSERT INTO Clients (ClientName, Email, Gender, IsRegular) VALUES
('Anton', 'gav@gmail.com', 'male', 'true'),
('Andrew', 'myau@mail.ru', 'male', 'false'),
('Natasha', 'hello@ukr.net', 'female', 'true'),
('Otto', 'otto@rambler.ru', 'male', 'false'),
('Ruslan', 'ruslan@u.ua','male', 'true'),
('Misha', 'mishka@ukr.net', 'male', 'false'),
('Viktor', 'illin@gmail.com', 'male', 'true'),
('Roman', 'roma@ukr.net', 'male', 'false'),
('Sasha', 'sash@mail.ru', 'male', 'true'),
('Vita', 'vita@u.ua', 'male', 'false'),
('Inna', 'innka@mail.ru', 'female', 'true')

SELECT ClientName
FROM Clients
WHERE ClientName LIKE 'A%';

INSERT INTO Rooms (RoomNumber, ÑomfortLevel, Capability, HotelId, Price) VALUES
(101,  2, 2, 1, 300),
(101,  2, 1, 2, 400),
(102,  2, 3, 1, 300),
(301,  2, 1, 1, 250),
(205,  3, 2, 2, 300),
(212,  2, 2, 1, 150),
(215,  3, 1, 2, 400),
(300,  1, 1, 1, 350),
(416,  2, 4, 1, 150),
(402,  2, 2, 1, 250)

SELECT * FROM Rooms
ORDER BY Price

SELECT * FROM Rooms
WHERE HotelId=1
ORDER BY Price

SELECT * 
FROM Hotels as H INNER JOIN Rooms as R
ON H.HotelId=R.HotelId
WHERE R.ÑomfortLevel=3

SELECT H.HotelName, R.RoomNumber
FROM Hotels as H INNER JOIN Rooms as R
ON H.HotelId=R.HotelId
WHERE R.ÑomfortLevel=1

SELECT H.HotelName, COUNT(R.RoomId) as RoomCount
FROM Hotels as H INNER JOIN Rooms as R
ON H.HotelId=R.HotelId
GROUP BY H.HotelName 

INSERT INTO Reservations(ReservationDate, ClientId, RoomId, StartDay, EndDate, Breakfast, Gym, SwimPool) VALUES
('2018-08-25',  10, 10, '2018-08-28', '2018-08-30', 'true', 'false', 'true'),
('2018-10-05',  9, 9, '2018-08-28', '2018-08-31', 'true', 'false', 'false'),
('2018-06-23',  8, 8, '2018-08-28', '2018-09-01', 'false', 'true', 'true'),
('2018-07-05',  7, 7, '2018-08-28', '2018-09-05', 'false', 'false', 'false'),
('2018-12-15',  6, 6, '2018-08-28', '2018-08-30', 'false', 'true', 'true'),
('2018-10-13',  5, 5, '2018-08-28', '2018-09-13', 'true', 'true', 'false'),
('2018-09-20',  4, 4, '2018-08-28', '2018-09-10', 'false', 'false', 'true'),
('2018-03-21',  3, 3, '2018-08-28', '2018-08-31', 'true', 'true', 'false'),
('2018-02-24',  1, 1, '2018-08-28', '2018-09-02', 'false', 'true', 'true'),
('2018-01-25',  2, 2, '2018-08-28', '2018-10-25', 'true', 'false', 'false')

SELECT C.ClientName, A.RoomNumber, R.StartDay, R.EndDate
FROM Reservations as R INNER JOIN Clients as C 
ON R.ClientId=C.ClientId 
INNER JOIN Rooms as A
ON A.RoomId=R.RoomId


-- customers who ordered rooms with breakfast (group by hotels)
SELECT C.ClientName, R.Breakfast, H.HotelName
FROM Clients as C JOIN Reservations as R
ON R.ClientId=C.ClientId
JOIN Rooms as Ro
ON Ro.RoomId=R.RoomId
JOIN Hotels as H
ON H.HotelId=Ro.HotelId
WHERE R.Breakfast = 'true' 
GROUP BY H.HotelName,C.ClientName,R.Breakfast

--hotels with at least 5 free rooms for the current date
SELECT H.HotelName FROM Hotels H
WHERE H.AvaliableRoomsCount >= 5

--customers who booked rooms only in the "hot" season
SELECT C.ClientName, R.StartDay, R.EndDate
FROM Clients as C JOIN Reservations as R
ON C.ClientId=R.ClientId
WHERE R.StartDay BETWEEN '2018-06-01' AND '2018-08-31'
AND R.EndDate BETWEEN '2018-06-01' AND '2018-08-31'

--cost of rooms considering the different types of discounts
SELECT Price,
(R.Price-R.Price*H.RegularDiscount/100) as Regular,
(R.Price-R.Price*H.SeasonalDiscount/100) as Seasonal
FROM Rooms as R JOIN Hotels as H 
ON H.HotelId=R.HotelId

--customers who had never ordered additional services
SELECT C.ClientName, R.Breakfast, R.Gym, R.SwimPool
FROM Clients as C JOIN Reservations as R
ON R.ClientId=C.ClientId
WHERE R.Breakfast='false' AND R.Gym='false' AND R.SwimPool='false'

--hotel that is the most popular in the winter
SELECT COUNT(Re.ReservationId) as Count,  H.HotelName
FROM Hotels as H JOIN Rooms as R
ON R.HotelId=H.HotelId
JOIN Reservations as Re
ON R.RoomId=Re.RoomId
WHERE Re.StartDay BETWEEN '2017-12-01' AND '2018-02-28'
AND Re.EndDate BETWEEN '2017-12-01' AND '2018-02-28'
GROUP BY H.HotelName

--hotels, customers and general amount of days the booked in hotels.
SELECT H.HotelName, C.ClientName, 
DATEDIFF(day, R.StartDay, R.EndDate) as DaysCount
FROM Hotels as H JOIN Rooms Ro 
ON Ro.HotelId=H.HotelId
JOIN Reservations as R
ON R.RoomId=Ro.RoomId
JOIN Clients as C
ON C.ClientId=R.ClientId


DROP TABLE Clients 
Go
DROP TABLE Hotels
GO
DROP TABLE Reservations
GO
DROP TABLE Rooms
GO