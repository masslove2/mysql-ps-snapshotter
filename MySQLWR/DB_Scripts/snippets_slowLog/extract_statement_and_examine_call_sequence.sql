
-- this one is used to identify exact parameter used when running certain statements

-- offloading subset of data for a certain statement - for the sake of performance


use wr

create table slow_log_20180524_lynxtax as 
select * from slow_log_20180524 l
 where l.sql_text like '%update%'
   and l.sql_text like '%lynxtax%'
  
-- identifies typical where clause statement for Hybris
-- so this will let you know if there were many calls using the same ID
update slow_log_20180524_cartent  
  set PKclause =   substr(sql_text from locate('PK = ',sql_text) )
  

select PKclause, start_time, sql_text
  from slow_log_20180524_cartent  
 order by PKclause, start_time 
 
