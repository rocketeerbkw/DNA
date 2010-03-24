CREATE VIEW VGuideEntryForumLastPosted WITH SCHEMABINDING
AS
    -- Get visible articles with a valid forumlastposted date.
	SELECT g.EntryID, f.LastPosted, CASE WHEN f.ForumPostCount > 0 THEN 1 ELSE 0 END 'HasPosts'
	  FROM dbo.GuideEntries g
			INNER JOIN dbo.Forums f on g.forumid = f.forumid
	 WHERE g.hidden is null AND g.status <>7
GO


CREATE UNIQUE CLUSTERED INDEX IX_VGuideEntryForumLastPosted ON VGuideEntryForumLastPosted
(
	EntryID,
	HasPosts,
	LastPosted
)
GO