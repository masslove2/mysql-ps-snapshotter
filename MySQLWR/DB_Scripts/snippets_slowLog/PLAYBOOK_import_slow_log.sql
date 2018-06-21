/*
This is a playbook to load slow_log data into a separate DB for further analysis
*/

-- 1. enable slow_log on a target DB
-- if it's AWS aurora instance - that's done by changing DB parameter groups
-- When you'd like to log all queries running on DB - use long_query_time = 0, but you SHOULD BE VERY CAREFUL as it may write a lot of data and affect performance)

-- 2. get slowlogdump from a Source DB
CLI command: (that assumes that remote DB connection is set up through SSH tunnel on port 3307)
mysqldump --lock-tables=false -h 127.0.0.1 -P 3307 -u epamdbuser -p   mysql slow_log > slow_log_dump.dmp

-- 3. get wr.slow_log table cleaned
truncate table wr.slow_log; -- WE need this to have InnoDB storage table in place (otherwise it's imported as CSV storage)

-- 4. import dump into slow_log table 
mysql -h 127.0.0.1 -P 3306 -u root -p WR < slow_log_dump.dmp

-- 5. create a separate table for certain date's slow log
create table wr.slow_log_20180322_20180404 as
select * from wr.slow_log

-- 6. clean up
truncate table wr.slow_log


-- ---------
-- 7. perform analysis by quering newly created table
select count(*), min(start_time), max(start_time) from wr.slow_log_20180322_20180404