DELIMITER $$

USE `test`$$

DROP PROCEDURE IF EXISTS `pr_order_placement1`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pr_order_placement1`(IN food_itm MEDIUMTEXT,IN food_qty MEDIUMTEXT,IN in_seat_name CHAR,OUT Result VARCHAR(100))
BEGIN
          DECLARE food1 TEXT DEFAULT NULL ;
          DECLARE foodlen1 INT DEFAULT NULL;
          DECLARE value1 TEXT DEFAULT NULL;
          DECLARE quant1 TEXT DEFAULT NULL ;
          DECLARE quantlen1 INT DEFAULT NULL;
          DECLARE value2 TEXT DEFAULT NULL;
          DECLARE order_id INT;
        
      /*To check whether there is service for curtime */
       IF(fn_is_service_available())
       THEN
       /*To check whether the order is vaild*/        
        IF LENGTH(TRIM(food_itm)) = 0 OR food_itm IS NULL OR LENGTH(TRIM(food_qty)) = 0 OR food_qty IS NULL THEN
          SET Result='Enter a valid order';
          ELSE              
          
       /*to check if given seat is null*/
       IF LENGTH(TRIM(in_seat_name))<>0
       THEN
       /*to check if given seat is available*/
        IF(fn_is_seat_available(in_seat_name))
THEN
UPDATE seat_info SET seat_status='Unavailable' WHERE seat_name=in_seat_name;
INSERT INTO order_info(seat_name) VALUES(in_seat_name);
SET order_id=(SELECT id FROM order_info WHERE seat_name=in_seat_name AND order_status='Requested');
    
IF (SELECT order_status FROM order_info WHERE id=order_id)='Requested'
THEN
         iterator :
                  LOOP
                  /*To split the items and quantities given as string*/    
            IF LENGTH(TRIM(food_itm)) = 0 OR food_itm IS NULL OR LENGTH(TRIM(food_qty)) = 0 OR food_qty IS NULL THEN
              LEAVE iterator;
              END IF;
  
                 SET food1 = SUBSTRING_INDEX(TRIM(food_itm),',',1);
                 SET foodlen1 = LENGTH(food1);
                 SET value1 = TRIM(food1);
                 
                 SET quant1 = SUBSTRING_INDEX(TRIM(food_qty),',',1);
                 SET quantlen1 = LENGTH(quant1);
                 SET value2 = TRIM(quant1);
                 
                
                 /*To validate given items and quantities*/
                CALL pr_order_calculation1(order_id,food1,quant1,@Result1);
               SET Result=@Result1;
                  
                
                SET food_itm = INSERT(food_itm,1,foodlen1 + 1,'');
                  SET food_qty = INSERT(food_qty,1,quantlen1 + 1,'');
                               
         END LOOP; 
          ELSE
SET Result='Your order has been cancelled';
END IF;     
         IF(fn_is_order_placed(order_id))=0
         THEN
         UPDATE order_info SET order_status='Not ordered' WHERE id=order_id;
         END IF;
         ELSE SET Result='Sorry,the given seat is currently unavailable';
         END IF;
         ELSE SET Result='Please provide appropriate seat number';
         END IF;
         END IF;
         ELSE SET Result='No Service!!';
END IF;
UPDATE seat_info SET seat_status='Available' WHERE seat_name=in_seat_name;     
    END$$

DELIMITER ;
