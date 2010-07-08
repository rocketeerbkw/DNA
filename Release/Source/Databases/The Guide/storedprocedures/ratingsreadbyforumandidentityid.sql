CREATE procedure ratingsreadbyforumandidentityid @uid varchar(255), @identityid varchar(40), @siteid int
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

select vr.*
from dbo.ForumReview ter
inner join commentforums cf on ter.forumid = cf.forumid
inner join vratings vr on vr.id = ter.entryid
inner join signInUserIDMapping sium on sium.dnauserid = ter.userId
where cf.uid=@uid 
and cf.siteid=@siteid 
and sium.identityuserid=@identityid