Create Procedure nntpfetchrange @forumid int, @start int, @end int
As
SELECT EntryID, Parent, ForumID, ThreadID, Subject, DatePosted, t.UserID, u.UserName, u.email, 'Bytes' = DATALENGTH(t.text) FROM ThreadEntries t 
	INNER JOIN Users u ON u.UserID = t.UserID
WHERE EntryID >= @start AND EntryID <= @end AND ForumID = @forumid AND (Hidden IS NULL)

	return (0)