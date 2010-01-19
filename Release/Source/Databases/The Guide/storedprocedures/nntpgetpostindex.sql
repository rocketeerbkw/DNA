Create Procedure nntpgetpostindex @entryid int
As
DECLARE @forumid int
SELECT @forumid = ForumID FROM ThreadEntries WHERE EntryID = @entryid
SELECT 'Index' = COUNT(*) FROM ThreadEntries
	WHERE ForumID = @forumid AND (Hidden IS NULL) AND EntryID <= @entryid
	return (0)