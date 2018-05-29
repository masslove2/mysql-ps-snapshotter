DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spRepWaits_Clear`()
begin
    TRUNCATE TABLE tmpRepWaits; 
end$$
DELIMITER ;

DELIMITER $$
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
end$$
DELIMITER ;
