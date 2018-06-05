DROP PROCEDURE `spRepStatements_Add_byIntervals`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spRepStatements_Add_byIntervals`(astartId int, afinishId int)
begin
  DECLARE curId int;  
  SET curId = astartId;
  
  lbl: loop    
	call spRepStatements_Add(curId, curId+1);
    SET curId = curId + 1;    
    if (curId > afinishId) then
      leave lbl;
    end if;
    
  
  end loop lbl;

    
end$$
DELIMITER ;



