use wr;

--
-- Dumping routines for database 'WR'
--
/*!50003 DROP PROCEDURE IF EXISTS `showdelta_accounts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `showdelta_accounts`(startId int, finishId int)
begin
	select USER, HOST, sum(TOTAL_CONNECTIONS*sign) as delta_TOTAL_CONNECTIONS
	  from wraccounts  a
	  join (   
	select @startId as snapId, -1 as sign
	union all 
	select @finishId as snapId, 1 as sign
	) b on (b.snapId = a.snapId)
	group by USER, HOST
    order by delta_TOTAL_CONNECTIONS desc
    ;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `showdelta_statementsdigest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `showdelta_statementsdigest`(startId int, finishId int)
begin
	SELECT ifnull(a.schema_name,'no schema'), a.digest_text
		 , sum(cast(count_star as signed)*sign) as Cnt
		 , round(sum(cast(SUM_TIMER_WAIT as signed)*sign)/1000000000000,2) as SUM_TIMER_WAIT_SEC
		 , round(sum(cast(SUM_LOCK_TIME as signed)*sign)/1000000000000,2) as SUM_LOCK_TIME_SEC
		 , sum(cast(SUM_ERRORS as signed)*sign) as SUM_ERRORS
		 , sum(cast(SUM_WARNINGS as signed)*sign) as SUM_WARNINGS
		 , sum(cast(SUM_ROWS_AFFECTED as signed)*sign) as SUM_ROWS_AFFECTED
		 , sum(cast(SUM_ROWS_SENT as signed)*sign) as SUM_ROWS_SENT
		 , sum(cast(SUM_ROWS_EXAMINED as signed)*sign) as SUM_ROWS_EXAMINED
         , sum(cast(SUM_CREATED_TMP_DISK_TABLES as signed)*sign) as SUM_CREATED_TMP_DISK_TABLES
         , sum(cast(SUM_CREATED_TMP_TABLES as signed)*sign) as SUM_CREATED_TMP_TABLES				
		 , min(first_seen)
		 , max(last_seen)     
	  FROM wrevents_statements_summary_by_digest a
	  join (   
			select startId as snapId, -1 as sign
			union all 
			select finishId as snapId, 1 as sign
		   ) b on (b.snapId = a.snapId)
     group by ifnull(a.schema_name,'no schema'), a.digest_text      
     having cnt > 0
     order by cnt desc
           ; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `showdelta_waitevents` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `showdelta_waitevents`(startId int, finishId int)
begin
	select * from (
	SELECT a.event_name, sum(cast(count_star as signed)*sign) as Cnt, min(COUNT_STAR), max(COUNT_STAR)
		 , round(sum(cast(SUM_TIMER_WAIT as signed)*sign)/1000000000000,2) as SUM_TIMER_WAIT_SEC 
	  FROM wrevents_waits_summary_global_by_event_name a
	  join (   
	select @startId as snapId, -1 as sign
	union all 
	select @finishId as snapId, 1 as sign
	) b on (b.snapId = a.snapId)
	 group by a.event_name
	) prep where cnt != 0 order by cnt desc; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spBulkDeleteUnneededSnapshotData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spBulkDeleteUnneededSnapshotData`()
begin
  DECLARE fcounter INT DEFAULT 10000;
  DECLARE fsnapId INT DEFAULT 0;
  DECLARE v_finished INTEGER DEFAULT 0;
  /*
  declare curSnap cursor for   
   select a.snapId from wrsnapshot a
    where (comments = 'AMWAY' or comments is null or comments='' or hostName ='MYAWS')
    order by a.snapId Desc;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;  
  */  
  
  
  snapLoop: LOOP
    select fsnapId = max(a.snapId)
      from wrsnapshot a
     where (comments = 'AMWAY' or comments is null or comments='' or hostName ='MYAWS')
       and a.snapId < fsnapId
     order by a.snapId Desc;
     			
    -- call spDeleteSnapshotData(fsnapId);
    
	IF fsnapId is null or fcounter > 10 THEN 
		LEAVE snapLoop;
	END IF;      
    
    SET fcounter = fcounter + fsnapId;    
  END LOOP snapLoop;
    	
  SELECT counter;      
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteSnapshotData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spDeleteSnapshotData`(asnapId int)
begin
    DELETE FROM wrglobal_status WHERE snapId = asnapId;
    DELETE FROM wraccounts WHERE snapId = asnapId;
    DELETE FROM wrevents_statements_summary_by_digest WHERE snapId = asnapId;
    DELETE FROM wrevents_waits_summary_global_by_event_name WHERE snapId = asnapId;
    DELETE FROM wrsnapshot WHERE snapId = asnapId;
    COMMIT;        
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRepGlobal_Status_Add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRepGlobal_Status_Clear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spRepGlobal_Status_Clear`()
begin
    TRUNCATE TABLE tmpRepGlobal_Status; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRepStatements_Add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spRepStatements_Add`(astartId int, afinishId int)
begin
    INSERT INTO tmpRepStatements (snapIdBeg, snapIdEnd, SCHEMA_NAME,DIGEST_TEXT,COUNT_STAR,SUM_TIMER_WAIT,SUM_LOCK_TIME,SUM_ROWS_SENT,SUM_ROWS_EXAMINED)
	SELECT astartId, afinishId
         , ifnull(a.schema_name,'no schema'), a.digest_text
		 , sum(cast(count_star as signed)*sign) as Cnt
		 , round(sum(cast(SUM_TIMER_WAIT as signed)*sign)/1000000000000,2) as SUM_TIMER_WAIT_SEC
		 , round(sum(cast(SUM_LOCK_TIME as signed)*sign)/1000000000000,2) as SUM_LOCK_TIME_SEC		 
         , round(sum(cast(SUM_ROWS_SENT as signed)*sign),2) as SUM_ROWS_SENT
         , round(sum(cast(SUM_ROWS_EXAMINED as signed)*sign),2) as SUM_ROWS_EXAMINED         
	  FROM wrevents_statements_summary_by_digest a
	  join (   
			select astartId as snapId, -1 as sign
			union all 
			select afinishId as snapId, 1 as sign
		   ) b on (b.snapId = a.snapId)
     group by ifnull(a.schema_name,'no schema'), a.digest_text      
     having cnt > 0
     order by cnt desc
           ; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRepStatements_Add_byIntervals` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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

    
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRepStatements_Clear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spRepStatements_Clear`()
begin
    DELETE FROM tmpRepStatements;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRepWaits_Add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spRepWaits_Add`(astartId int, afinishId int)
begin
    INSERT INTO tmpRepWaits (snapIdBeg, snapIdEnd, EVENT_NAME, COUNT_STAR, SUM_TIMEr_WAIT)
    select astartId, afinishId, EVENT_NAME, sum(cnt), round(sum(SUM_TIMER_WAIT)/1000000000000,2) as SUM_TIMEr_WAIT
    from 
    (
	SELECT event_name			
		 , sum(count_star) as Cnt
		 , sum(SUM_TIMER_WAIT) as SUM_TIMER_WAIT
	  FROM wrevents_waits_summary_global_by_event_name a
     WHERE a.snapId = afinishId
     group by event_name		
     
     UNION ALL 
     
	SELECT event_name			
		 , -1*sum(count_star) as Cnt
		 , -1*sum(SUM_TIMER_WAIT) as SUM_TIMER_WAIT
	  FROM wrevents_waits_summary_global_by_event_name a
     WHERE a.snapId = astartId     
     group by event_name		
     ) b     
     where b.EVENT_NAME != 'idle'
     group by b.EVENT_NAME
           ; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRepWaits_Clear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `spRepWaits_Clear`()
begin
    TRUNCATE TABLE tmpRepWaits; 
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

