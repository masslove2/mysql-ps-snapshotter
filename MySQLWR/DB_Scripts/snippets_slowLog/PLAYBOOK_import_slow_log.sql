-- 1. get slowlogdump from a Source DB

CLI command:
mysqldump --lock-tables=false -h 127.0.0.1 -P 3307 -u epamdbuser -p   mysql slow_log > slow_log_dump.dmp


-- 2. get wr.slow_log table cleaned

truncate table wr.slow_log; -- WE need this to have InnoDB storage table in place (otherwise it's imported as CSV storage)

-- 3. import dump into slow_log table

mysql -h 127.0.0.1 -P 3306 -u root -p WR < slow_log_dump.dmp

-- 4. create a separate table for certain date's slow log

create table wr.slow_log_20180322_20180404 as
select * from wr.slow_log

-- 5. clean up

truncate table wr.slow_log




-- ---------
select count(*), min(start_time), max(start_time) from wr.slow_log