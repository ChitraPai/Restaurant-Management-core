DELIMITER $$

USE `test`$$

DROP PROCEDURE IF EXISTS `pr_order_calculation1`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pr_order_calculation1`(IN i_order_id INT,IN i_item VARCHAR(40),IN i_item_quant INT,OUT Result1 VARCHAR(100))
BEGIN
/*To check if given quantity is negative*/
IF i_item_quant>0
THEN
/*To check if given item is served in the restaurant*/
IF(fn_is_item_present(i_item))
THEN
/*To get the meal id based on the current time*/
IF(fn_get_meal_id(i_item)<>0)
THEN
/*To check if given order contains only 5 items*/
IF(fn_check_order_count(i_order_id))
THEN
/*Processes the given order and checks for the availability of the stock*/
SET Result1=fn_is_item_available1(i_order_id,i_item,i_item_quant);
ELSE
SET Result1= CONCAT('you can order only 5 times in a single order');
 END IF;
 ELSE
 SET Result1= CONCAT('The ordered ',i_item,' is not served now.You can order items available now from the menu');
 END IF;
 ELSE SET Result1= CONCAT(i_item,' is not served in our restaurant.','Please order available items');
 END IF;
 ELSE SET Result1='Provide appropriate food quantity.It cannot be negative value.';
 END IF;
 END$$

DELIMITER ;