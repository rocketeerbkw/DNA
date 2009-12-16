CREATE PROCEDURE gettopicdetails @topicstatus int = 0,@siteid int = 0
As
IF ( @siteid > 0 )
BEGIN
	SELECT t.TopicID, t.h2g2ID, t.SiteID, t.TopicStatus, t.TopicLinkID, g.Subject AS 'Title', g.ForumID, 'ForumPostCount' = f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = f.ForumID), t.Position
	FROM dbo.Topics t
	INNER JOIN dbo.GuideEntries g ON g.EntryID = t.h2g2ID/10 AND t.SiteID = g.SiteID
	LEFT JOIN dbo.Forums f ON f.ForumID = g.ForumID
	WHERE t.TopicStatus = @topicstatus	AND t.SiteID = @siteid
	ORDER BY t.Position
END
ELSE
BEGIN
	SELECT t.TopicID, t.h2g2ID, t.SiteID, t.TopicStatus, t.TopicLinkID, g.Subject AS 'Title', g.ForumID, 'ForumPostCount' = f.ForumPostCount + (select isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = f.ForumID), t.Position
	FROM dbo.Topics t
	INNER JOIN dbo.GuideEntries g ON g.EntryID = t.h2g2ID/10 AND t.SiteID = g.SiteID
	LEFT JOIN dbo.Forums f ON f.ForumID = g.ForumID
	WHERE t.TopicStatus = @topicstatus
	ORDER BY t.SiteID, t.Position
END

	
  