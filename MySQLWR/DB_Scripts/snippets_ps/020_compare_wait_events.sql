/*

This snippet is for comparing wait events during 2 tests.

Let's say we had one test yesterday (beginning snapshot ID is 141, final one = 151)
and one more test today (snapshot ID   begin: 300, end: 310)

We would like to compare wait events between two tests

*/

use wr;
-- 1. identify snapshot ID for our tests
SELECT * FROM wrsnapshot order by snapId desc

-- 2. prepare data (data is written into tmprepwaits)
call spRepWaits_Clear(); -- clean up
call spRepWaits_Add(@astartId := 141, @afinishId := 151); -- test1
call spRepWaits_Add(@astartId := 300, @afinishId := 310); -- test2
-- NOTE: You can include more than 2 test into comparison

-- ------------------------------------------
-- 4. This statement compares count and wait time for individual wait events during Test1 and Test2
-- by default events are sorted by number of occurances. 
-- Sorting is done by greatest value in either tests (so we won't miss anything if statements was called very often in Test1 and, say, had just a few calls during Test2)
-- how to change sorting parameter - see below
SELECT a.snapIdBeg, a.event_name
     , COUNT_STAR as CountExec
     , SUM_TIMER_WAIT as ExecTime_Total	
  FROM tmprepwaits a
  JOIN (SELECT x.event_name, max(COUNT_STAR) as maxCount_Star, max(SUM_TIMER_WAIT) as maxSUM_TIMER_WAIT
		  FROM tmprepwaits x
		 GROUP BY x.event_name
       ) dgtStats on (dgtStats.event_name = a.event_name)  
 order by dgtStats.maxCount_Star desc, snapIdBeg -- this sorts by number of occurances
 -- order by dgtStats.maxSUM_TIMER_WAIT desc, snapIdBeg -- this sorts by total wait time
 
 

