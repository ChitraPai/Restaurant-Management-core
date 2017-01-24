/*Checks if there is service for the current time*/
DELIMITER ##
CREATE FUNCTION fn_is_service_available()
RETURNS BOOLEAN
BEGIN
RETURN(EXISTS(SELECT CURTIME()FROM meals_type WHERE CURTIME() BETWEEN meals_type.`FROM_TIME` AND meals_type.`To_TIME`));
END ##
DELIMITER ;



/*Checks the seat availability*/
DELIMITER ##
CREATE FUNCTION fn_is_seat_available(in_seat_name CHAR)
RETURNS BOOLEAN
BEGIN
RETURN((SELECT seat_status FROM seat_info WHERE seat_name=in_seat_name)='Available');
END ##
DELIMITER ;

/*Checks whether the item is served in the restaurant*/
DELIMITER ##
CREATE FUNCTION fn_is_item_present(i_item_name VARCHAR(30))
RETURNS BOOLEAN
BEGIN
RETURN(EXISTS(SELECT item_name FROM menu_items WHERE item_name=i_item_name));
END ##
DELIMITER ;



/*Retrieves the meal id based on current time*/
DELIMITER ##
CREATE FUNCTION fn_get_meal_id(in_item_name VARCHAR(40))
RETURNS INT
BEGIN
DECLARE itm_id INT;
DECLARE m_id INT DEFAULT 0;
SELECT id INTO itm_id FROM menu_items WHERE ITEM_NAME=in_item_name;
SELECT DISTINCT(MEAL_ID) INTO m_id
FROM item_schedule INNER JOIN MEALS_TYPE
WHERE item_schedule.`ITEM_ID`=itm_id
AND item_schedule.`MEAL_ID` IN(
SELECT meals_type.`ID`FROM meals_type WHERE
CURTIME()>=meals_type.`FROM_TIME` 
AND CURTIME()<=meals_type.`To_TIME`); 
RETURN(m_id);
END ##
DELIMITER ;

/*Function to restrict the order count */
DELIMITER ##
CREATE FUNCTION fn_check_order_count(in_order_id INT)
RETURNS BOOLEAN
BEGIN
RETURN((SELECT COUNT(DISTINCT(items_id))FROM order_transaction WHERE order_id=in_order_id)<5);
END ##
DELIMITER ;

/*Function to check availability of the given item */
DELIMITER ##
CREATE FUNCTION fn_is_item_available(in_order_id INT,i_item_name VARCHAR(40),i_item_qty INT)
RETURNS VARCHAR(100)
BEGIN
DECLARE tot_itm INT;
DECLARE rem_itm INT;
DECLARE used_itm INT;
DECLARE i_id INT;
SET i_id=(SELECT id FROM menu_items WHERE item_name=i_item_name);
SELECT quantity INTO tot_itm FROM item_schedule WHERE item_id=i_id AND meal_id=fn_get_meal_id(i_item_name);
    SELECT SUM(items_qty) INTO used_itm FROM order_transaction WHERE items_id=i_id AND DATE(time_stamp)=CURDATE();
    IF used_itm IS NULL
    THEN SET used_itm=0;
    END IF;    
    
    SET rem_itm=tot_itm-used_itm;
  
    IF rem_itm>=i_item_qty
        THEN
     
     INSERT INTO order_transaction(order_id,items_id,items_qty,time_stamp) VALUES(in_order_id,i_id,i_item_qty,NOW());
      UPDATE order_info SET order_status='Served' WHERE id=in_order_id;
    RETURN(CONCAT(i_item_name,' is ordered.'));
    ELSE
    RETURN(CONCAT('Sorry the ordered ',i_item_name,' is out of stock'));
    END IF;
END ##
DELIMITER ;


