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
)
GO

INSERT INTO Hotels (HotelName, StarsCount, CreationYear, Adress, IsActive) VALUES
('Edelweiss', '5', '2005', 'Ulica Myra', 'true'),
('Bucovina', '4', '2000', 'Holovna', 'true'),
('Cheremosh', '3', '2010', 'Heroiv Maidanu', 'fasle')

SELECT * FROM Hotels

UPDATE Hotels
SET CreationYear ='1937'
WHERE HotelId='1'

DELETE FROM Hotels
WHERE HotelId='3'

INSERT INTO Clients (ClientName, Email, Gender) VALUES
('Anton', 'gav@gmail.com', 'male'),
('Andrew', 'myau@mail.ru', 'male'),
('Natasha', 'hello@ukr.net', 'female'),
('Otto', 'otto@rambler.ru', 'male'),
('Ruslan', 'ruslan@u.ua','male'),
('Misha', 'mishka@ukr.net', 'male'),
('Viktor', 'illin@gmail.com', 'male'),
('Roman', 'roma@ukr.net', 'male'),
('Sasha', 'sash@mail.ru', 'male'),
('Vita', 'vita@u.ua', 'male'),
('Inna', 'innka@mail.ru', 'female')

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

INSERT INTO Reservations(ReservationDate, ClientId, RoomId, StartDay, EndDate) VALUES
('2018-08-25',  10, 10, '2018-08-28', '2018-08-30'),
('2018-10-05',  9, 9, '2018-08-28', '2018-08-31'),
('2018-06-23',  8, 8, '2018-08-28', '2018-09-01'),
('2018-07-05',  7, 7, '2018-08-28', '2018-09-05'),
('2018-12-15',  6, 6, '2018-08-28', '2018-08-30'),
('2018-10-13',  5, 5, '2018-08-28', '2018-09-13'),
('2018-09-20',  4, 4, '2018-08-28', '2018-09-10'),
('2018-03-21',  3, 3, '2018-08-28', '2018-08-31'),
('2018-02-24',  1, 1, '2018-08-28', '2018-09-02'),
('2018-01-25',  2, 2, '2018-08-28', '2018-10-25')

SELECT C.ClientName, A.RoomNumber, R.StartDay, R.EndDate
FROM Reservations as R INNER JOIN Clients as C 
ON R.ClientId=C.ClientId 
INNER JOIN Rooms as A
ON A.RoomId=R.RoomId

DROP TABLE Clients 
Go
DROP TABLE Hotels
GO
DROP TABLE Reservations
GO
DROP TABLE Rooms
GO