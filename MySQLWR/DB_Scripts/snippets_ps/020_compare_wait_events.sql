SELECT * FROM wrsnapshot order by snapId desc

call spRepWaits_Clear();

call spRepWaits_Add(@astartId := 141, @afinishId := 151); -- old baseline from march
call spRepWaits_Add(@astartId := 176, @afinishId := 186); -- 5/22 test rampUp
call spRepWaits_Add(@astartId := 193, @afinishId := 203); -- 5/22 test rampUp№2
call spRepWaits_Add(@astartId := 300, @afinishId := 310); -- 5/22 test rampUp№2

-- ------------------------------------------

SELECT a.snapIdBeg, a.event_name
     , COUNT_STAR as CountExec
     , SUM_TIMER_WAIT as ExecTime_Total	
  FROM tmprepwaits a
  JOIN (SELECT x.event_name, max(COUNT_STAR) as maxCount_Star, max(SUM_TIMER_WAIT) as maxSUM_TIMER_WAIT
		  FROM tmprepwaits x
		 GROUP BY x.event_name
       ) dgtStats on (dgtStats.event_name = a.event_name)  
 order by dgtStats.maxSUM_TIMER_WAIT desc
        , snapIdBeg 

