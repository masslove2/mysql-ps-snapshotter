call showdelta_statementsdigest(@startId := 61, @finishId := 62);


--------------------------------------------------------------------------------------------------
/*
SET @startId = 61, @finishId = 62;
drop procedure showdelta_statementsdigest
delimiter $$
create procedure showdelta_statementsdigest(startId int, finishId int)
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
		 , min(first_seen)
		 , max(last_seen)     
	  FROM wrevents_statements_summary_by_digest a
	  join (   
			select @startId as snapId, -1 as sign
			union all 
			select @finishId as snapId, 1 as sign
		   ) b on (b.snapId = a.snapId)
     group by ifnull(a.schema_name,'no schema'), a.digest_text      
     having cnt > 0
     order by cnt desc
           ; 
end$$
*/

select * from wrevents_statements_summary_by_digest where snapId in (61,62)
and digest_text like '%p1%'
order by DIGEST_TEXT, snapid