/*

This snippet is for comparing client connections during 2 tests.

Let's say we had one test yesterday (beginning snapshot ID is 141, final one = 151)
and one more test today (snapshot ID   begin: 300, end: 310)

We would like to compare number of opened connections over test period, minimum/maximum number of concurrently opened connections
*/

use wr;
-- 1. identify snapshot ID for our tests
select * from wrsnapshot order by snapId desc

-- 2. Comparing SQL (you should change snapshot IDs below)
-- more than 2 tests can be included into comparison
select  c.name, min(curConn) as minCurConn, max(curConn) as maxCurConn, max(totalConn) - min(totalConn) as connOpenedDuringTest
  from (select snapId, user, sum(current_connections) as curConn, sum(total_connections) totalConn
		  from wraccounts a
         where user = 'hybris' 
		 group by snapId, user 
       ) b
  join (select 'Test1' as name, 141 as snapIdBeg, 151 as snapIdEnd              
         union all select 'Test2' , 300 , 310
       ) c on (b.snapId between c.snapIdBeg and c.snapIdEnd) 
 group by c.name, c.snapIdBeg, c.snapIdEnd
 order by c.name, c.snapIdBeg, c.snapIdEnd