call spRepStatements_Clear
---------------------------------------------------------------------------
call spRepStatements_Add(107,117)
call spRepStatements_Add(118,128)
call spRepStatements_Add(129,140)
call spRepStatements_Add(141,151)
---------------------------------------------------------------------------
select snapIDBeg, SCHEMA_NAME, sum(count_star) as number_of_calls, sum(sum_timer_wait) as execution_time, sum(sum_lock_time) as lockwait_time
  from tmpRepStatements 
 where schema_name = 'hybris' 
 group by snapIDBeg,SCHEMA_NAME
 order by SCHEMA_NAME, snapIDBeg
---------------------------------------------------------------------------
alter table tmpRepStatements add opertype varchar(100)

update tmpRepStatements set opertype = 'SELECT' where digest_text like 'select%'
update tmpRepStatements set opertype = 'DML and COMMIT' where digest_text like 'update%'
update tmpRepStatements set opertype = 'DML and COMMIT' where digest_text like 'delete%'
update tmpRepStatements set opertype = 'DML and COMMIT' where digest_text like 'insert%'
update tmpRepStatements set opertype = 'DML and COMMIT' where digest_text like 'commit%'
update tmpRepStatements set opertype = 'other' where opertype is null
---------------------------------------------------------------------------
select snapIDBeg, SCHEMA_NAME, opertype, sum(count_star) as number_of_calls, sum(sum_timer_wait) as execution_time, sum(sum_lock_time) as lockwait_time
  from tmpRepStatements 
 where schema_name = 'hybris' 
 group by snapIDBeg,SCHEMA_NAME, opertype
 order by SCHEMA_NAME, opertype, snapIDBeg
---------------------------------------------------------------------------
select distinct digest_text from tmpRepStatements where opertype = 'other'
 
select snapIDBeg, digest_text, sum(count_star), sum(sum_timer_wait), sum(sum_lock_time)
 from tmpRepStatements 
 group by snapIDBeg, digest_text
 order by sum(count_star) desc
 
select * from 
select * from tmpRepStatements  a
where a.snapidBeg in (107,118) and schema_name = 'hybris'
and (count_star > 30000 or sum_timer_wait > 100)
order by count_star desc