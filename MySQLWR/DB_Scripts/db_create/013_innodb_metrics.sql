create table wr.wrinnodb_metrics as  
select 1000 as snapId, a.*
  from information_schema.innodb_metrics a  
 where 1 = 0


