
use WR
select * from wrSnapshot order by snapId desc
select * from wraccounts where snapId > 34 order by snapId desc

/**************************************/

select b.snapTime, a.snapId, user, sum(CURRENT_CONNECTIONS), sum(TOTAL_CONNECTIONS) 
  from wraccounts a 
  join wrSnapshot b on (b.snapId = a.snapID)
  /*where user = 'hybris' */
  group by b.snapTime, a.snapId, user 
  order by a.snapId, user 