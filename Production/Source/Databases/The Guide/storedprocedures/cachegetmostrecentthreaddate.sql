CREATE PROCEDURE cachegetmostrecentthreaddate @forumid int
AS
declare @lastupdated int
	select @lastupdated = ISNULL(DATEDIFF(second, max(LastUpdated), getdate()),60*60*12)
		FROM ForumLastUpdated WITH(NOLOCK)
		where ForumID = @forumid
SELECT 'MostRecent' = CASE WHEN 60*60*12 < @lastupdated THEN 60*60*12 ELSE @lastupdated END
