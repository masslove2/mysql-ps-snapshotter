select * from wrsnapshot wr order by snapId desc

call spRepStatements_Clear();

call spRepStatements_Add(@astartId := 141, @afinishId := 151); -- old baseline from march
call spRepStatements_Add(@astartId := 193, @afinishId := 203); -- 5/23 clean solrindex
call spRepStatements_Add(@astartId := 300, @afinishId := 310); -- 5/23 clean solrindex

delete from tmprepstatements where schema_name != 'hybris'

-- ------------------------------------------

SELECT a.snapIdBeg, a.digest_text
     , COUNT_STAR as CountExec
     , SUM_TIMER_WAIT as ExecTime_Total
     , round(SUM_TIMER_WAIT / COUNT_STAR * 1000,2) as ExecTime_Per1000Execs
     , SUM_LOCK_TIME, SUM_ROWS_EXAMINED, SUM_ROWS_SENT
  FROM tmprepstatements a
  JOIN (SELECT x.DIGEST_TEXT, max(COUNT_STAR) as maxCount_Star, max(SUM_TIMER_WAIT) as maxSUM_TIMER_WAIT, max(SUM_ROWS_EXAMINED) as maxSUM_ROWS_EXAMINED
		  FROM tmprepstatements x
		 GROUP BY x.DIGEST_TEXT
       ) dgtStats on (dgtStats.digest_text = a.digest_text)  
 order by dgtStats.maxSUM_ROWS_EXAMINED desc
        , snapIdBeg 

