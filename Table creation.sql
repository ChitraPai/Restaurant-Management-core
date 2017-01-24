/*Table that contains meal type details*/
CREATE TABLE MEALS_TYPE
(
ID INT PRIMARY KEY,
MEAL_NAME VARCHAR(20) NOT NULL,
FROM_TIME TIME NOT NULL,
TO_TIME TIME NOT NULL
)


INSERT INTO MEALS_TYPE VALUES(1,'Breakfast','08:00:00','11:00:00'),(2,'Lunch','11:15:00','15:00:00'),(3,'Refereshment','15:15:00','23:00:00'),(4,'Dinner','19:00:00','23:00:00')

/*Table that has items details*/
CREATE TABLE MENU_ITEMS
(
ID INT PRIMARY KEY AUTO_INCREMENT,
ITEM_NAME VARCHAR(25) NOT NULL,
PRICE INT NOT NULL
)

INSERT INTO MENU_ITEMS VALUES(1,'Idly',30),(2,'Vada',15),(3,'Dosa',45),(4,'Pongal',40),(5,'Poori',50),(6,'Coffee',20),(7,'Tea',18),(8,'South Indian Meals',80),(9,'North Indian Thali',90),(10,'Variety Rice',100),(11,'Snacks',40),(12,'Fried Rice',70),(13,'Chappathi',55),(14,'Chat Items',45)

/*Table that maintains the schedule of the items served*/
CREATE TABLE ITEM_SCHEDULE
(
ID INT PRIMARY KEY,
MEAL_ID INT NOT NULL,
ITEM_ID INT NOT NULL,
CONSTRAINT FK_MEAL_ID FOREIGN KEY(MEAL_ID) REFERENCES MEALS_TYPE(ID),
CONSTRAINT FK_ITEM_ID FOREIGN KEY(ITEM_ID) REFERENCES MENU_ITEMS(ID)
)

INSERT INTO ITEM_SCHEDULE VALUES(1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,1,7),(8,2,8),(9,2,9),(10,2,10),(11,3,6),(12,3,7),(13,3,11),(14,4,12),(15,4,13),(16,4,14)


/*Table to maintain seat information*/
CREATE TABLE SEAT_INFO
(
ID INT PRIMARY KEY AUTO_INCREMENT,
SEAT_NAME CHAR,
SEAT_STATUS VARCHAR(15) DEFAULT 'Available'
)


INSERT INTO SEAT_INFO(SEAT_NAME) VALUES('A'),('B'),('C'),('D'),('E'),('F'),('G'),('H'),('I'),('J')





/* Table to generate order id*/
CREATE TABLE ORDER_INFO
(
ID INT PRIMARY KEY AUTO_INCREMENT,
SEAT_NAME VARCHAR(25),
ORDER_STATUS VARCHAR(20) DEFAULT 'Requested'
)


/* Transaction table*/
CREATE TABLE ORDER_TRANSACTION
(
ID INT PRIMARY KEY AUTO_INCREMENT,
ORDER_ID INT NOT NULL,
ITEMS_ID INT NOT NULL,
ITEMS_QTY INT NOT NULL,
TIME_STAMP TIMESTAMP NOT NULL,
ORDER_STATUS VARCHAR(15) DEFAULT 'Served',
CONSTRAINT fk_item_id FOREIGN KEY(items_id) REFERENCES menu_items(id),
CONSTRAINT fk_order_id FOREIGN KEY(order_id) REFERENCES order_info(id)  
)




