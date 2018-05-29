DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spRepStatements_Clear`()
begin
    DELETE FROM tmpRepStatements;
end$$
DELIMITER ;

DELIMITER $$
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
end$$
DELIMITER ;
