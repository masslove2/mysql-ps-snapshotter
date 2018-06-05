DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spRepGlobal_Status_Clear`()
begin
    TRUNCATE TABLE tmpRepGlobal_Status; 
end$$
DELIMITER ;

-- drop PROCEDURE `spRepGlobal_Status_Add` 
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spRepGlobal_Status_Add`(astartId int, afinishId int)
begin
    INSERT INTO tmpRepGlobal_Status (snapIdBeg, snapIdEnd, variable_name, deltaValue, minimumValue, maximumValue)
    select astartId, afinishId, variable_name
         , sum(variable_valueNum)
         , min(variable_value), max(variable_value)
    from 
    (
	SELECT variable_name			
		 , variable_value
         , case when variable_value REGEXP '^[0-9]+$' = 1 then 0+variable_value else 0 end as variable_valueNum
	  FROM wrglobal_status a1
     WHERE a1.snapId = afinishId	
     
     UNION ALL 
     
	SELECT variable_name			
		 , variable_value         
         , -1*case when variable_value REGEXP '^[0-9]+$' = 1 then 0+variable_value else 0 end as variable_valueNum
	  FROM wrglobal_status a2
     WHERE a2.snapId = astartId			
     ) b          
     group by b.variable_name
           ; 
end$$
DELIMITER ;


