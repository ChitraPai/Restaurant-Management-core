/*Procedure to calculate remaining stock at any time*/
CREATE VIEW vw_stock AS
SELECT ITM_SH.`ITEM_ID`,M.`ITEM_NAME` AS ITEMS,M_T.`MEAL_NAME`,ITM_SH.`QUANTITY` AS TOTAL,
IFNULL(SUM(O.`ITEMS_QTY`),0) AS CONSUMED,
IFNULL(ITM_SH.`QUANTITY`-SUM(O.`ITEMS_QTY`),ITM_SH.`QUANTITY`) AS REMAINING
FROM item_schedule ITM_SH
LEFT JOIN menu_items M
ON M.`ID`=ITM_SH.`ITEM_ID`
LEFT JOIN meals_type M_T
ON M_T.`ID`=ITM_SH.`MEAL_ID`
LEFT JOIN order_transaction O
ON O.`ITEMS_ID`=M.`ID`
AND EXISTS 
		( SELECT 1 FROM meals_type WHERE ID = M_T.ID AND TIME(O.`TIME_STAMP`) BETWEEN FROM_TIME AND TO_TIME )
AND DATE(O.`TIME_STAMP`)=CURDATE()
	GROUP BY ITM_SH.`ID`		
