Create Procedure nntpfetcharticleforforum @forumid int
As
Select TOP 1 u.UserName, u.email, g.Subject, g.text, g.Status, g.h2g2ID, 'Parent' = NULL, 'Bytes' = DATALENGTH(g.text), 'DatePosted' = g.DateCreated 
	FROM GuideEntries g
	INNER JOIN Users u ON g.Editor = u.UserID
	WHERE g.ForumID = @forumid
