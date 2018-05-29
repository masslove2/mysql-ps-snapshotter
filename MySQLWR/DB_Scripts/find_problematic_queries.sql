set @startId = 148, @finishId = 151 /* prepare snap range */
------------------------------------------------------------------------
/* long running:
	take more than 0.1 sec per call
    - total time consumed over period > 10sec    
*/
select SUM_TIMER_WAIT_SEC/Cnt as time_per_sec, a.*
  from (
	SELECT a.digest, a.digest_text
		 , sum(cast(count_star as signed)*sign) as Cnt
		 , round(sum(cast(SUM_TIMER_WAIT as signed)*sign)/1000000000000,2) as SUM_TIMER_WAIT_SEC
		 , round(sum(cast(SUM_LOCK_TIME as signed)*sign)/1000000000000,2) as SUM_LOCK_TIME_SEC			
	  FROM wrevents_statements_summary_by_digest a
	  join (   
			select @startId as snapId, -1 as sign
			union all 
			select @finishId as snapId, 1 as sign
		   ) b on (b.snapId = a.snapId)
     group by ifnull(a.schema_name,'no schema'), a.digest, a.digest_text      
     having cnt > 0
) a     
 where SUM_TIMER_WAIT_SEC/Cnt > 0.1 and SUM_TIMER_WAIT_SEC > 10
     order by SUM_TIMER_WAIT_SEC/Cnt desc
------------------------------------------------------------------------
/* inefficient indexes:
	rows_examined / rows_sent > 10
    - no aggreagates (count, max)
    - no DML (rows_affected = 0)
    - total time consumed > 10 sec
*/
select SUM_ROWS_EXAMINED/(SUM_ROWS_SENT+1) as ratio, a.*
  from (
	SELECT a.digest, a.digest_text
		 , sum(cast(SUM_ROWS_SENT as signed)*sign) as SUM_ROWS_SENT
		 , sum(cast(SUM_ROWS_EXAMINED as signed)*sign) as SUM_ROWS_EXAMINED    
		 , sum(cast(count_star as signed)*sign) as Cnt
		 , round(sum(cast(SUM_TIMER_WAIT as signed)*sign)/1000000000000,2) as SUM_TIMER_WAIT_SEC
		 , round(sum(cast(SUM_LOCK_TIME as signed)*sign)/1000000000000,2) as SUM_LOCK_TIME_SEC		 
		 , sum(cast(SUM_ROWS_AFFECTED as signed)*sign) as SUM_ROWS_AFFECTED         
	  FROM wrevents_statements_summary_by_digest a
	  join (   
			select @startId as snapId, -1 as sign
			union all 
			select @finishId as snapId, 1 as sign
		   ) b on (b.snapId = a.snapId)
     group by ifnull(a.schema_name,'no schema'), a.digest, a.digest_text      
     having cnt > 0
) a     
 where SUM_ROWS_EXAMINED/(SUM_ROWS_SENT+1) > 10 and SUM_ROWS_affected = 0 and SUM_TIMER_WAIT_SEC > 10 and digest_text not like '%COUNT (%' and digest_text not like '%MAX (%'
     order by SUM_ROWS_EXAMINED/SUM_ROWS_SENT desc
------------------------------------------------------------------------     
/* tmp tables created (memory or disk:
	SUM_CREATED_TMP_DISK_TABLES + SUM_CREATED_TMP_TABLES > 0
    - total time consumed > 10 sec
*/
select a.*
  from (
	SELECT a.digest, a.digest_text
         , sum(cast(SUM_CREATED_TMP_DISK_TABLES as signed)*sign) as SUM_CREATED_TMP_DISK_TABLES
         , sum(cast(SUM_CREATED_TMP_TABLES as signed)*sign) as SUM_CREATED_TMP_TABLES				         
		 , sum(cast(count_star as signed)*sign) as Cnt
		 , round(sum(cast(SUM_TIMER_WAIT as signed)*sign)/1000000000000,2) as SUM_TIMER_WAIT_SEC
		 , round(sum(cast(SUM_LOCK_TIME as signed)*sign)/1000000000000,2) as SUM_LOCK_TIME_SEC
	  FROM wrevents_statements_summary_by_digest a
	  join (   
			select @startId as snapId, -1 as sign
			union all 
			select @finishId as snapId, 1 as sign
		   ) b on (b.snapId = a.snapId)
     group by ifnull(a.schema_name,'no schema'), a.digest, a.digest_text      
     having cnt > 0
) a     
 where SUM_CREATED_TMP_DISK_TABLES + SUM_CREATED_TMP_TABLES > 0
    and SUM_TIMER_WAIT_SEC > 10
     order by SUM_CREATED_TMP_DISK_TABLES + SUM_CREATED_TMP_TABLES desc