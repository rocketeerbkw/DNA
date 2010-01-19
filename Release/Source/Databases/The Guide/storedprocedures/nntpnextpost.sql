Create Procedure nntpnextpost @entryid int
As
declare @forumid int
SELECT @forumid = ForumID FROM ThreadEntries WHERE ENtryID = @entryid
SELECT TOP 1 EntryID FROM ThreadEntries WHERE ForumID = @forumid AND (Hidden IS NULL) AND EntryID > @entryid ORDER BY EntryID ASC

	return (0)