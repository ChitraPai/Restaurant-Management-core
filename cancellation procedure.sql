/*Cancellation procedure*/
DELIMITER ##
CREATE PROCEDURE pr_order_cancellation(IN input_seat_name CHAR,OUT Message VARCHAR(40))
BEGIN
IF EXISTS(SELECT seat_name FROM seat_info WHERE seat_name=input_seat_name)
THEN
IF (SELECT id FROM order_info WHERE seat_name=input_seat_name AND order_status='Requested') IS NOT NULL
THEN 
UPDATE order_info SET order_status='Cancelled' WHERE seat_name=input_seat_name AND order_status='Requested';
SET Message='Your order has been cancelled';
ELSE
SET Message='Sorry,you cannot cancel the given order';
END IF;
ELSE
SET Message='Provide appropriate seat name';
END IF;
END ##
DELIMITER ;