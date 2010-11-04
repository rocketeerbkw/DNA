CREATE PROCEDURE getsiteevents_newuser
AS


set transaction isolation level read uncommitted;

declare @eventtype int
select @eventtype= 0

exec seteventtypevalinternal 'ET_NEWUSERTOSITE', @eventtype OUTPUT

SELECT 

      p.datejoined as 'DateCreated'
      , p.userid as 'user_userid'
      , dbo.udf_getusername(p.siteid, p.userid) as 'user_username'
      , p.siteid
from dbo.SiteActivityQueue saq
inner join dbo.preferences p on p.userid=saq.ItemID and p.siteid=saq.ItemID2
where saq.EventType = @eventType