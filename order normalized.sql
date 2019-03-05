#recreate the test db in original form
DROP DATABASE orderNormdb;
CREATE DATABASE orderNormdb;
USE orderNormdb;

CREATE TABLE item(
	itemName		varchar(30)			PRIMARY KEY,				
	itemType		varchar(30),
	itemCost		decimal(15,2)
);

INSERT INTO item VALUES 
	('Handbag',			'Wearable',	'20.30'),
    ('Car',				'Vehicle',	'5000.99'),
    ('Dog',				'Pet',		'200.00'),
    ('Cat',				'Pet',		'150.00'),
    ('Dinosaur',		'Pet',		'50000.00'),
    ('Van',				'Vehicle',	'20000.00'),
    ('Hat',				'Wearable',	'5.10'),
    ('Leather Jacket',	'Wearable',	'90.00'),
    ('DinoCart',		'Vehicle',	'2000.00')
;
    

CREATE TABLE buyer(
	buyerID			int					PRIMARY KEY auto_increment,
	buyerName		varchar(100),
	buyerDoB		date
);

INSERT INTO buyer VALUES 
	('1',	'Geoff Knightly',		'1934-03-23'),
    ('2',	'Laura Knightly',		'1944-03-23'),
    ('3',	'Harry Harryson',		'1983-03-23'),
    ('4',	'Grugg Thunderfist',	'1001-01-01'),
    ('5',	'Laura Mint',			'1934-03-23')
;

CREATE TABLE address(
	fullAddress		varchar(200)		PRIMARY KEY,
	houseType		varchar(30)
);

INSERT INTO address VALUES 
	('89, Harrison Road OJ8 75YU',	'Flat'),
    ('33, Randomname Road OJ8 23DU','House'),
    ('94, Big Rock OJ8 35GF',		'House'),
    ('4533, Jeg Road OJ8 7DYU',		'Flat'),
    ('81, Harrison Road OJ8 75YU',	'House')
;

CREATE TABLE registeredLocs(
	fullAddress		varchar(200),
	buyerID			int,
	PRIMARY KEY (fullAddress, buyerID),
    FOREIGN KEY (fullAddress) REFERENCES address (fullAddress),
    FOREIGN KEY (buyerID) REFERENCES buyer (buyerID)
);

INSERT INTO registeredLocs VALUES 
	('89, Harrison Road OJ8 75YU',	'1'),
    ('89, Harrison Road OJ8 75YU',	'2'),
    ('33, Randomname Road OJ8 23DU','3'),
    ('94, Big Rock OJ8 35GF',		'4'),
    ('4533, Jeg Road OJ8 7DYU',		'5'),
    ('81, Harrison Road OJ8 75YU',	'1')
;

CREATE TABLE registeredCards(
	card			int8,
    buyerID			int,
    PRIMARY KEY (card, buyerID),
    FOREIGN KEY (buyerID) REFERENCES buyer (buyerID)
);

INSERT INTO registeredCards VALUES 
	('345435435435345',	'1'),
    ('345435435435345',	'2'),
    ('234235345654334',	'3'),
    ('876454564634534',	'4'),
    ('765436547647657',	'5'),
    ('857675464334345',	'1')
;

CREATE TABLE orders(
	orderNumber		int					PRIMARY KEY auto_increment,
    orderDate		timestamp,
    deliveryDate	date,
    buyerID			int,
    card			int8,
    fullAddress		varchar(200),
    FOREIGN KEY (fullAddress) REFERENCES address (fullAddress),
    FOREIGN KEY (buyerID) REFERENCES buyer (buyerID),
    FOREIGN KEY (card, buyerID) REFERENCES registeredCards (card, buyerID)
);

CREATE TABLE audits(
	auditID			int					PRIMARY KEY auto_increment,
    orderNumber		int,
    buyerID			int,
    FOREIGN KEY (orderNumber) REFERENCES orders (orderNumber),
    FOREIGN KEY (buyerID) REFERENCES buyer (buyerID)
);

CREATE TRIGGER auditlog AFTER INSERT ON orders
FOR EACH ROW 
INSERT INTO audits VALUES (null, NEW.orderNumber, NEW.buyerID);

INSERT INTO orders VALUES
('1', '2019-04-03 13:50:34', '2019-04-05', '1', '345435435435345', '89, Harrison Road OJ8 75YU'),
('2', '2019-02-01 14:30:34', '2019-05-05', '2', '345435435435345', '89, Harrison Road OJ8 75YU'), 
('3', '2004-04-03 10:50:34', '2011-04-05', '3', '234235345654334', '33, Randomname Road OJ8 23DU'), 
('4', '2000-04-03 05:50:34', '1001-04-05', '4', '876454564634534', '94, Big Rock OJ8 35GF'), 
('5', '2019-04-06 23:50:34', '2019-04-07', '5', '765436547647657', '4533, Jeg Road OJ8 7DYU'), 
('6', '2014-04-03 13:50:34', '2019-04-05', '1', '857675464334345', '81, Harrison Road OJ8 75YU')
;
CREATE TABLE itemOrder(
	orderNumber		int,
    itemName		varchar(30),
    itemQuantity	int,
    PRIMARY KEY (orderNumber, itemName),
    FOREIGN KEY (orderNumber) REFERENCES orders (orderNumber),
    FOREIGN KEY (itemName) REFERENCES item (itemName)
);

INSERT INTO itemOrder VALUES
('1', 'Handbag', '1'),
('1', 'Hat', '1'),
('2', 'Car', '1'),
('3', 'Dog', '2'),
('3', 'Cat', '1'),
('4', 'Dinosaur', '1'),
('4', 'Leather Jacket', '1'),
('4', 'DinoCart', '1'),
('5', 'Hat', '2'),
('6', 'Van', '1')
;

SELECT * FROM audits;

#find the cost of a given order
SELECT SUM(unitCost) AS total
FROM
(SELECT item.itemCost * itemOrder.itemQuantity AS unitCost
FROM  
	itemOrder
		INNER JOIN
	item ON itemOrder.itemName = item.itemName
WHERE
	itemOrder.orderNumber = 3
) as findCost;