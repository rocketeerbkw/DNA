Create Procedure subscribetothread @userid int, @threadid int, @forumid int
as
IF NOT EXISTS (SELECT * FROM ThreadPostings WHERE UserID = @userid AND ThreadID = @threadid)
BEGIN
	declare @postcount int
	declare @curtime datetime
	declare @lastuserpost int, @lastuserpostdate datetime
	
	SELECT @postcount = COUNT(*), @curtime = MAX(DatePosted) FROM ThreadEntries
		WHERE ThreadID = @threadid -- AND (Hidden IS NULL)
		
	SELECT @lastuserpost = MAX(EntryID), @lastuserpostdate = MAX(DatePosted)
		FROM ThreadEntries
		WHERE ThreadID = @threadid AND (Hidden IS NULL) AND UserID = @userid
		OPTION (OPTIMIZE FOR (@threadid=0,@userid=0))
		
	declare @private int
	select @private = CASE WHEN CanRead = 0 THEN 1 ELSE 0 END FROM Threads WHERE ThreadID = @threadid

	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, 
								LastUserPostID, ForumID, Replies, CountPosts, Private)
		VALUES(@userid, @threadid, @curtime, @lastuserpostdate, @lastuserpost, 
			@forumid, CASE WHEN @curtime = @lastuserpostdate THEN 0 ELSE 1 END, 
			@postcount, @private)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	IF EXISTS (SELECT * FROM Users WHERE UserID=@userid AND Journal = @forumid)
	BEGIN
		INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
			VALUES(@forumid, getdate())
--		UPDATE Forums Set LastUpdated = getdate() WHERE ForumID = @forumid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END

	COMMIT TRANSACTION

END