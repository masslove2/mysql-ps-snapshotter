/*

This snippet is for comparing query performance during 2 tests.

Let's say we had one test yesterday (beginning snapshot ID is 141, final one = 151)
and one more test today (snapshot ID   begin: 300, end: 310)

We would like to compare number of queries, execution time, etc., so we can asses changes between two tests

*/

use wr;
-- 1. identify snapshot ID for our tests
select * from wrsnapshot wr order by snapId desc

-- 2. prepare data (data is written into tmprepstatements)
call spRepStatements_Clear(); -- clean up
call spRepStatements_Add(@astartId := 141, @afinishId := 151); -- add data for test1
call spRepStatements_Add(@astartId := 300, @afinishId := 310); -- add data for test2
-- NOTE: You can include more than 2 test into comparison

-- 3. this deletes irrelevant statements when we analyze Hybris perf
delete from tmprepstatements where schema_name != 'hybris' 

-- ------------------------------------------
-- 4. This statement compares how individual SQL statements performed during Test1 and Test2
-- by default SQLs are sorted by number of executions (starting from most often called). 
-- Sorting is done by greatest value in either tests (so we won't miss anything if statements was called very often in Test1 and, say, had just a few calls during Test2)
-- how to change sorting parameter - see below
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
 order by dgtStats.maxCount_Star desc, snapIdBeg -- this sorts by number of calls
-- order by dgtStats.maxSUM_TIMER_WAIT desc, snapIdBeg -- this sorts by execution time
-- order by dgtStats.maxSUM_ROWS_EXAMINED desc, snapIdBeg -- this sorts by amount of data reads



