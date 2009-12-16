CREATE VIEW VGuideEntryForumPostCount WITH SCHEMABINDING
AS
	SELECT g.EntryID, f.ForumPostCount
	  FROM dbo.GuideEntries g
			INNER JOIN dbo.Forums f on g.forumid = f.forumid
	 WHERE g.hidden is null 
	   AND g.status <>7
GO

CREATE UNIQUE CLUSTERED INDEX IX_VGuideEntryForumPostCount ON VGuideEntryForumPostCount
(
	EntryID,
	ForumPostCount
)
GO