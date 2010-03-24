CREATE procedure ratingsreadbyforumanduser @uid varchar(255), @userid int, @siteid int
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

select vr.*
from dbo.ForumReview ter
inner join commentforums cf on ter.forumid = cf.forumid
inner join vratings vr on vr.id = ter.entryid
where cf.uid=@uid 
and cf.siteid=@siteid 
and ter.userId=@userid