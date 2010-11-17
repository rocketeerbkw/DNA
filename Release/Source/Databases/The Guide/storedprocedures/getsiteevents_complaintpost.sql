CREATE PROCEDURE getsiteevents_complaintpost
AS


set transaction isolation level read uncommitted;

declare @eventtype int
select @eventtype= 0

exec seteventtypevalinternal 'ET_COMPLAINTRECIEVED', @eventtype OUTPUT

SELECT 

      tm.datequeued as 'DateCreated'
      ,tm.Notes
      , tm.complainantID as 'complaintantID_userid'
      , case when tm.complainantID is null then '' else dbo.udf_getusername(tm.siteid, tm.complainantID) end as 'complainantUserName'
      , tm.siteid
      , tm.postid
      , tm.threadid
      , tm.forumid
      , tm.status
      , tm.complainttext
      , cf.url as 'parenturl'
      , te.subject
from dbo.SiteActivityQueue saq
inner join dbo.threadmod tm on tm.modid=saq.ItemID
INNER JOIN dbo.threadentries te ON te.entryid = tm.postid
left join commentforums cf on cf.forumid = tm.forumid
where saq.EventType = @eventType
