SELECT * FROM wrsnapshot order by snapId desc

call spRepGlobal_Status_Clear();

call spRepGlobal_Status_Add(@astartId := 317, @afinishId := 327); 
call spRepGlobal_Status_Add(@astartId := 345, @afinishId := 355); 

-- ------------------------------------------

SELECT a.snapIdBeg, a.variable_name
     , deltaValue, minimumValue, maximumValue
  FROM tmpRepGlobal_Status a
 order by variable_name
        , snapIdBeg 

