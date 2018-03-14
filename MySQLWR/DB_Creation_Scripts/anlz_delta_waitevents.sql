call showdelta_waitevents(@startId := 73, @finishId := 74);


--------------------------------------------------------------------------------------------------
/*
SET @startId = 61, @finishId = 62;
drop procedure showdelta_waitevents
delimiter $$
create procedure showdelta_waitevents(startId int, finishId int)
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
end$$
*/


