CREATE PROCEDURE getsiteevents_postmoderationdecision
AS


set transaction isolation level read uncommitted;

declare @eventtype int
select @eventtype= 0

exec seteventtypevalinternal 'ET_MODERATIONDECISION_POST', @eventtype OUTPUT

SELECT 

      tmh.eventdate as 'DateCreated'
      ,tmh.Notes
      , te.userid as 'author_userid'
      , dbo.udf_getusername(tm.siteid, te.userid) as 'author_username'
      , tm.lockedby as 'mod_userid'
      , dbo.udf_getusername(tm.siteid, tmh.lockedby) as 'mod_username'
      , tm.siteid
      , tm.postid
      , tm.threadid
      , tm.forumid
      , tmh.status
      , mr.displayname as 'modreason'
      , cf.url as 'parenturl'
from dbo.SiteActivityQueue saq
inner join dbo.threadmodhistory tmh on tmh.historymodid=saq.ItemID
inner join dbo.threadmod tm on tm.modid = tmh.modid
INNER JOIN dbo.threadentries te ON te.entryid = tm.postid
LEFT JOIN dbo.ModReason mr on mr.reasonid = tmh.reasonid
left join commentforums cf on cf.forumid = tm.forumid
where saq.EventType = @eventType