CREATE PROCEDURE nntpfetchpost @entryid int
 AS
SELECT EntryID, ForumID, Parent, ThreadID, Subject, DatePosted, t.UserID, u.UserName, u.email, t.text FROM ThreadEntries t 
	INNER JOIN Users u ON u.UserID = t.UserID
WHERE EntryID = @entryid
