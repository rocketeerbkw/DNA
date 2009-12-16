/*
	Returns info on users most recent session, plus a flag indicating
	whether they are deemed to be online (i.e. have done anything in the
	last 15 minutes)
*/

create procedure fetchuserslastsession @userid int
as
-- Disable this feature as it takes a long time, rendering the moderation stats page useless
-- And it was being called multiple times, which is bad coding practice
return (0)
select top 1	*,
				'Online' = case when (DateLastLogged > dateadd(minute,-15,getdate())) then 1 else 0 end,
				'MinutesIdle' = datediff(minute, DateLastLogged, getdate())
from Sessions WITH(NOLOCK)
where UserID = @userid
order by SessionID desc
return (0)
