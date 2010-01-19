Create Procedure getpostsinthread @postid int
As
SELECT u.UserID, 'UserName' = CASE WHEN LTRIM(u.UserName) = '' THEN 'Researcher ' + CAST(u.UserID AS varchar) ELSE u.UserName END, t.EntryID, t.DatePosted, t.Subject, t.ThreadID, t.ForumID, t.text
FROM ThreadEntries t
INNER JOIN Users u ON u.UserID = t.UserID
WHERE t.ThreadID IN (SELECT t1.ThreadID FROM ThreadEntries t1 WHERE t1.EntryID = @postid)
ORDER BY t.DatePosted
	return (0)
