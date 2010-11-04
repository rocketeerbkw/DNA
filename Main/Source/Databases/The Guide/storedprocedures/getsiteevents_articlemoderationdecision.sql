CREATE PROCEDURE getsiteevents_articlemoderationdecision
AS


set transaction isolation level read uncommitted;

declare @eventtype int
select @eventtype= 0

exec seteventtypevalinternal 'ET_MODERATIONDECISION_ARTICLE', @eventtype OUTPUT

SELECT amh.ModID
      ,amh.StatusID
      ,amh.ReasonID
      ,amh.ActionID
      ,amh.LockedByChanged
      ,amh.LockedBy
      ,amh.TriggerID
      ,amh.TriggeredBy
      ,amh.DateCreated
      ,amh.Notes
      , g.editor as 'author_userid'
      , dbo.udf_getusername(g.siteid, g.editor) as 'author_username'
      , am.lockedby as 'mod_userid'
      , dbo.udf_getusername(g.siteid, am.lockedby) as 'mod_username'
      , g.siteid
      , g.h2g2id
      , case when mr.DisplayName is null then '' else mr.DisplayName end as 'ModReason'
from dbo.SiteActivityQueue saq
inner join dbo.articlemodhistory amh on amh.modid=saq.ItemID and amh.statusid= saq.ItemID2
inner join dbo.articlemod am on am.modid = amh.modid
INNER JOIN dbo.GuideEntries g ON g.h2g2Id = am.h2g2Id
LEFT JOIN dbo.ModReason mr on mr.reasonid = amh.reasonid
where saq.EventType = @eventType