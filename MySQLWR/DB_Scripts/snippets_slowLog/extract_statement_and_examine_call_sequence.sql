-- check if slow log table is not in CSV storage (dates are processed incorrectly otherwise)
use wr

create table slow_log_20180524_lynxtax as 
select * from slow_log_20180524 l
 where l.sql_text like '%update%'
   and l.sql_text like '%lynxtax%'
  

update slow_log_20180524_cartent  
  set PKclause =   substr(sql_text from locate('PK = ',sql_text) )
  

select PKclause, start_time, sql_text
  from slow_log_20180524_cartent  
 order by PKclause, start_time 
 
