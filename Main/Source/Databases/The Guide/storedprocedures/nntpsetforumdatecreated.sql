Create Procedure nntpsetforumdatecreated
As
UPDATE Forums Set DateCreated = (SELECT MIN(DateCreated) FROM Threads t WHERE t.ForumID = Forums.ForumID)
UPDATE Forums Set DateCreated = (SELECT TOP 1 g.DateCreated FROM GuideEntries g WHERE g.ForumID = Forums.ForumID)
	WHERE DateCreated IS NULL
UPDATE Forums Set DateCreated = '1 Jan 2000' WHERE DateCreated IS NULL
	return (0)