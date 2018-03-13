call showdelta_accounts(@startId := 61, @finishId := 62);


--------------------------------------------------------------------------------------------------
/*
SET @startId = 61, @finishId = 62;
drop procedure showdelta_accounts
delimiter $$
create procedure showdelta_accounts(startId int, finishId int)
begin
	select USER, HOST, sum(TOTAL_CONNECTIONS*sign) as delta_TOTAL_CONNECTIONS
	  from wraccounts  a
	  join (   
	select @startId as snapId, -1 as sign
	union all 
	select @finishId as snapId, 1 as sign
	) b on (b.snapId = a.snapId)
	group by USER, HOST;
end$$
*/