CREATE procedure commentforumgetlastupdate @uid varchar(255), @siteid int
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

declare @lastUpdate datetime

select @lastUpdate = max(lastupdated)
from dbo.ForumLastUpdated flu
inner join dbo.commentforums cf on cf.forumid=flu.forumid 
where cf.siteid = @siteid and cf.uid=@uid

if @lastUpdate is null
BEGIN

	select @lastUpdate = case when f.lastupdated > f.lastposted then f.lastupdated else f.lastposted end
	from dbo.Forums f
	inner join dbo.commentforums cf on cf.forumid=f.forumid
	where cf.siteid = @siteid and cf.uid=@uid

END


select @lastUpdate as lastupdated
