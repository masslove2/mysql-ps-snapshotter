use wr
select * from wrsnapshot order by snapId desc

select  c.name, min(curConn) as minCurConn, max(curConn) as maxCurConn, max(totalConn) - min(totalConn) as connOpenedDuringTest
  from (select snapId, user, sum(current_connections) as curConn, sum(total_connections) totalConn
		  from wraccounts a
         where user = 'hybris' 
		 group by snapId, user 
       ) b
  join (select 'March' as name, 141 as snapIdBeg, 151 as snapIdEnd     
         union all select 'May-23 table clean' , 245, 255
         union all select 'May-28 monitor on' , 300 , 310
         union all select 'May-29 #1' , 317 , 327            
		 union all select 'May-29 #2' , 344 , 354
       ) c on (b.snapId between c.snapIdBeg and c.snapIdEnd) 
 group by c.name, c.snapIdBeg, c.snapIdEnd
 order by c.name, c.snapIdBeg, c.snapIdEnd