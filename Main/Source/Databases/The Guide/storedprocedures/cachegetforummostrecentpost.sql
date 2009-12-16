CREATE   PROCEDURE cachegetforummostrecentpost @forumid int, @threadid int
AS
	declare @lastupdated int
	declare @postcount int
	select @postcount = ThreadPostCount
		FROM Threads t WITH(NOLOCK) WHERE t.ThreadID = @threadid
	select @lastupdated = ISNULL(DATEDIFF(second, max(LastUpdated), getdate()),60*60*12)
		FROM ForumLastUpdated WITH(NOLOCK)
		where ForumID = @forumid

	SELECT  'DatePosted' = 
		CASE 
		WHEN 60*60*12 < @lastupdated
		THEN 
			60*60*12 
		ELSE 
			@lastupdated
		END, 
		'NumPosts' = @postcount 
