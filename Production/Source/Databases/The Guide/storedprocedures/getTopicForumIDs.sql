CREATE PROCEDURE gettopicforumids @topicstatus int = 1,@siteid int = 0
As
set transaction isolation level read uncommitted
DECLARE @Count int

SELECT @Count = Count(*) From Topics WHERE TopicStatus = @topicstatus AND SiteID = @siteid
IF ( @siteid > 0 )
BEGIN
	SELECT 'Count' = @Count,
	g.ForumID
	FROM Topics as t
	INNER JOIN GuideEntries as g ON t.h2g2ID = g.h2g2ID AND t.SiteID = g.SiteID
	WHERE t.TopicStatus = @topicstatus AND t.SiteID = @siteid
	ORDER BY g.ForumID
END
ELSE
BEGIN
	SELECT 'Count' = @Count, g.ForumID
	FROM Topics as t
	INNER JOIN GuideEntries as g ON t.h2g2ID = g.h2g2ID AND t.SiteID = g.SiteID
	WHERE t.TopicStatus = @topicstatus
	ORDER BY t.SiteID, g.ForumID
END

	
  