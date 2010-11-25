CREATE PROCEDURE getsiteevents_complaintarticle
AS


set transaction isolation level read uncommitted;

declare @eventtype int
select @eventtype= 0

exec seteventtypevalinternal 'ET_COMPLAINTRECIEVED', @eventtype OUTPUT

SELECT 

      am.datequeued as 'DateCreated'
      , am.complainantID as 'complaintantID_userid'
      , case when am.complainantID is null then '' else dbo.udf_getusername(am.siteid, am.complainantID) end as 'complainantUserName'
      , am.siteid
      , am.h2g2id
      , am.complainttext
      , g.subject
from dbo.SiteActivityQueue saq
inner join dbo.articlemod am on am.modid=saq.ItemID
INNER JOIN dbo.guideentries g ON g.h2g2id = am.h2g2id
where saq.EventType = @eventType
