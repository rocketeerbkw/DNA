Create Procedure nntpfetchposts @forumid int
As
SELECT EntryID FROM ThreadEntries t 
WHERE ForumID = @forumid AND (Hidden IS NULL)
ORDER BY EntryID
	return (0)