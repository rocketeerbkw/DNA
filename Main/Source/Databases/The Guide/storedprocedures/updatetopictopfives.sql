Create Procedure updatetopictopfives @siteid int = 0
As
BEGIN TRANSACTION

DECLARE @ErrorCode int

-- remove all topic top fives for the site in question
DELETE TopFives 
WHERE TopicID > 0 AND SiteID = @siteid

-- Top Recently created discussions
INSERT INTO dbo.TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID, TopicID)
	SELECT TOP 5 'MostRecent', 'Most Recent Discussions', @siteid, g.ForumID, te.ThreadID, tt.TopicID
	FROM dbo.ThreadEntries te
	INNER JOIN dbo.Threads t ON te.ThreadID = t.ThreadID
	INNER JOIN dbo.GuideEntries g ON g.ForumID = te.ForumID
	INNER JOIN dbo.Topics tt ON tt.h2g2ID = g.h2g2ID
	WHERE g.SiteID = @SiteID AND
	g.CanRead = 1 AND
	tt.TopicStatus = 0 AND
	(te.Hidden IS NULL OR te.Hidden = 0) AND
	-- in the last hour
	te.DatePosted > DATEADD(HOUR, -1, GetDate())
	ORDER BY te.DatePosted DESC
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError


-- Top Busiest Topics
INSERT INTO dbo.TopFives (GroupName, GroupDescription, SiteID, ForumID, TopicID)
	SELECT TOP 5 'MostThreads', '5 Busiest Conversations', @siteid, g.ForumID, tt.TopicID
	FROM
	(
		SELECT top 5 g.forumid, 'PostCount' = COUNT(*) FROM dbo.ThreadEntries te
		INNER JOIN dbo.GuideEntries g on g.ForumID = te.ForumID
		INNER JOIN dbo.Topics t ON t.h2g2ID = g.h2g2ID
		WHERE	g.SiteID = @SiteID AND
				g.CanRead = 1 AND
				t.TopicStatus = 0 AND
				(te.Hidden IS NULL OR te.Hidden = 0) AND
				-- in the last 12 hours
				te.DatePosted > DATEADD(HOUR, -12, GetDate())
		GROUP BY g.ForumID
		ORDER BY 'PostCount' desc
	) AS c
	INNER JOIN dbo.GuideEntries g ON g.ForumID = c.ForumID
	INNER JOIN dbo.Topics tt ON tt.h2g2ID = g.h2g2ID
	ORDER BY c.PostCount desc
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError



-- Top Busiest Discussions
INSERT INTO dbo.TopFives (GroupName, GroupDescription, SiteID, ForumID, ThreadID, TopicID)
	SELECT TOP 5 'MostPosts', '5 Busiest Discussions', @siteid, g.ForumID, c.ThreadID, tt.TopicID
	FROM
	(
		SELECT top 200 t.ThreadID, 'PostCount' = COUNT(*) FROM Threads t
		INNER JOIN dbo.ThreadEntries te ON te.ThreadID = t.ThreadID
		INNER JOIN dbo.GuideEntries g on g.ForumID = t.ForumID
		INNER JOIN dbo.Topics tt ON tt.h2g2ID = g.h2g2ID
		WHERE	g.SiteID = @SiteID AND
				g.CanRead = 1 AND
				(te.Hidden IS NULL OR te.Hidden = 0) AND
				tt.TopicStatus = 0 AND
				-- in the last hour
				te.DatePosted > DATEADD(HOUR, -12, GetDate())
		GROUP BY t.ThreadID
		ORDER BY 'PostCount' desc
	) AS c
	INNER JOIN dbo.Threads t ON t.ThreadID = c.ThreadID
	INNER JOIN dbo.Forums f ON f.ForumID = t.ForumID
	INNER JOIN dbo.GuideEntries g ON g.ForumID = f.ForumID
	INNER JOIN dbo.Topics tt ON tt.h2g2ID = g.h2g2ID
	ORDER BY c.PostCount desc
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError	
	
ReturnWithoutError:
COMMIT TRANSACTION
SELECT 'result'='ok'
RETURN 0

HandleError:
ROLLBACK TRANSACTION
EXEC Error @ErrorCode
RETURN @ErrorCode
