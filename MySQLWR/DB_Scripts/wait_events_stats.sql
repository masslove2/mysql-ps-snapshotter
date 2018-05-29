use performance_schema
select * from table_io_waits_summary_by_table 
order by sum_timer_wait desc


select * from events_waits_summary_global_by_event_name order by sum_timer_wait desc

use hybris
select count(*) from tasks
select count(*) from taskconditions

select * from information_schema.tables
where table_name like 'task%'