CREATE PROCEDURE cachegetmostrecentreviewforumthreaddate @reviewforumid int
AS

declare @forumid int
Select @forumid =  forumid from Reviewforums r with(nolock) inner join guideentries g with(nolock) on r.h2g2id = g.h2g2id where reviewforumid = @reviewforumid  

declare @lastupdated int
	select @lastupdated = ISNULL(DATEDIFF(second, max(LastUpdated), getdate()),60*60*12)
		FROM ForumLastUpdated
		where ForumID = @forumid

SELECT 'MostRecent' = CASE WHEN 60*60*12 < @lastupdated THEN 60*60*12 ELSE @lastupdated END

return (0)