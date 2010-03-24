Create Procedure nntpfetchall @forumid int
As
SELECT EntryID, Parent, ForumID, ThreadID, Subject, DatePosted, t.UserID, u.UserName, u.email, 'Bytes' = DATALENGTH(t.text) FROM ThreadEntries t 
	INNER JOIN Users u ON u.UserID = t.UserID
WHERE ForumID = @forumid AND (Hidden IS NULL)
ORDER BY EntryID

	return (0)