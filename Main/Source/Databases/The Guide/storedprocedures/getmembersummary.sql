create procedure getmembersummary @userid int
as
begin
	DECLARE @postcount INT
	SELECT @postcount = count(*) FROM ThreadEntries WHERE userid = @userid

	DECLARE @entrycount INT
	SELECT @entrycount = count(*) FROM GuideEntries WHERE  editor = @userid

	--Count failed posts.
	DECLARE @failedposts INT
	SELECT @failedposts = COUNT(*) FROM ThreadMod tm
	INNER JOIN ThreadEntries te ON te.EntryId = tm.PostID
	WHERE te.UserId = @userId AND Status = 4

	--Count failed entries.
	DECLARE @failedentries INT
	SELECT @failedentries = COUNT(*) FROM ArticleMod am
	INNER JOIN GuideEntries g ON g.h2g2Id = am.h2g2Id
	WHERE g.editor = @userid AND am.Status = 4

	--Date Joined 
	DECLARE @datejoined DATETIME
	SELECT @datejoined = DateJoined FROM Users WHERE userid = @userid

	SELECT	@postcount 'postcount', 
			@entrycount 'entrycount', 
			@failedposts 'failedposts', 
			@failedentries 'failedentries',
			@datejoined    'datejoined'

end