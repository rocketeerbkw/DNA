CREATE PROCEDURE getsiteevents_usermoderation
AS


set transaction isolation level read uncommitted;

declare @eventtype int
select @eventtype= 0

exec seteventtypevalinternal 'ET_USERMODERATION', @eventtype OUTPUT

SELECT 

      upsa.updated as 'DateCreated'
      , upsaa.userid as 'user_userid'
      , dbo.udf_getusername(upsaa.siteid, upsaa.userid) as 'user_username'
      , upsa.userid as 'mod_userid'
      , dbo.udf_getusername(upsaa.siteid, upsa.userid) as 'mod_username'
      , upsaa.siteid
      , case when upsa.DeactivateAccount =1 then 5 else upsaa.newprefstatus end as 'status'
      , upsa.reason as 'modreason'
      , upsaa.prefduration
from dbo.SiteActivityQueue saq
inner join dbo.userprefstatusaudit upsa on upsa.userupdateid=saq.ItemID
inner join dbo.userprefstatusauditactions upsaa on upsa.userupdateid = upsaa.userupdateid
where saq.EventType = @eventType