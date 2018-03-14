call showdelta_accounts(@startId := 73, @finishId := 74);

use WR
select * from wrsnapshot where snapId in (74,75)

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
	group by USER, HOST
    order by delta_TOTAL_CONNECTIONS desc
    ;
end$$
*/

	select USER, sum(TOTAL_CONNECTIONS*sign) as delta_TOTAL_CONNECTIONS
	  from wraccounts  a
	  join (   
	select @startId as snapId, -1 as sign
	union all 
	select @finishId as snapId, 1 as sign
	) b on (b.snapId = a.snapId)
	group by USER
    order by delta_TOTAL_CONNECTIONS desc