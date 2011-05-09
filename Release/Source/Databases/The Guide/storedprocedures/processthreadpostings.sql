CREATE procedure processthreadpostings
as

declare @entryid int
declare @ErrorCode int

declare @threadid INT, @forumid int, @threadread int, @userid int, @postcount int, @inreplyto int, @queueid int
declare @curtime datetime

WHILE 1=1
BEGIN

select @threadid = NULL

BEGIN TRANSACTION

select 	TOP 1 
	@queueid = ID,
	@entryid = t.EntryID,
	@threadid = t.threadid, 
	@forumid = t.forumid, 
	@threadread = th.CanRead, 
	@userid = t.userid, 
	@postcount = t.postindex,
	@inreplyto = Parent,
	@curtime = DatePosted
	from ThreadPostingsQueue q
		join ThreadEntries t WITH(NOLOCK) ON q.EntryID = t.EntryID
		join threads th WITH(NOLOCK) on t.ThreadID = th.ThreadID
	order by q.ID
	
IF @threadid IS NOT NULL
BEGIN

--Note: We *don't* add an entry for the posting user if this is a new thread, because that's already done in posttoforuminternal 
--Add entries for subscribed users.
IF (@inreplyto IS NULL)
BEGIN

	INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, 
								ForumID, Replies, CountPosts, Private)
		--VALUES(@userid, @threadid, @curtime, @curtime, @forumid, 0, 0)
		SELECT UserID, @threadid, @curtime, NULL, @forumid,0,1, CASE WHEN @threadread = 1 THEN 0 ELSE 1 END
			FROM FaveForums WHERE ForumID = @forumid AND UserID <> @userid
				AND (@threadread = 1 OR UserID IN (SELECT m.UserID FROM ThreadPermissions t INNER JOIN TeamMembers m ON t.TeamID = m.TeamID WHERE t.ThreadID = @threadid AND t.CanRead = 1))
--		UNION
--		SELECT @userid, @threadid, @curtime, NULL, @forumid,0,0, CASE WHEN @threadread = 1 THEN 0 ELSE 1 END
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

/*
IF NOT EXISTS (SELECT * FROM ThreadPostings WHERE UserID = @userid AND ThreadID = @threadid)
BEGIN
	INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, 
								ForumID, Replies, CountPosts, Private)
		VALUES(@userid, @threadid, @curtime, @curtime, @forumid, 0, @postcount, CASE WHEN @threadread = 1 THEN 0 ELSE 1 END)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
*/

UPDATE ThreadPostings WITH(HOLDLOCK)
	SET LastPosting = @curtime, CountPosts = @postcount+1, Replies = CASE WHEN UserID = @userid THEN 0 ELSE 1 END,
		LastUserPosting = CASE WHEN UserID = @userid /*AND LastUserPosting < @curtime*/ THEN @curtime ELSE LastUserPosting END,
		LastUserPostID = CASE WHEN UserID = @userid /*AND LastUserPosting < @curtime*/ THEN @entryid ELSE LastUserPostID END
		WHERE ThreadID = @threadid -- AND LastPosting < @curtime
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

/*
UPDATE ThreadPostings
	SET LastUserPosting = @curtime, Replies = 0, LastUserPostID = @entryid
		WHERE ThreadID = @threadid AND UserID = @userid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END
*/

-- Optimisation - if the threadread=0, it could be a private thread
IF @threadread = 0
BEGIN
	-- Update users subscribed to this thread ( should be 2 users for private messaging: sender + recipient )
	-- Only update recipient where post hasn't been already read ( posts could have been read before this sp is processed ).
	UPDATE dbo.Users SET UnreadPrivateMessageCount = UnreadPrivateMessageCount + 1 WHERE UserID IN
	(
		SELECT UserID FROM dbo.ThreadPostings WHERE ThreadID = @ThreadID 
		AND Private = 1 AND LastPostCountRead < CountPosts AND UserID <> @userid
		
	)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

DELETE FROM ThreadPostingsQueue WHERE ID = @queueid

END
ELSE
BEGIN
	WAITFOR DELAY '00:00:01'
END

COMMIT TRANSACTION

END
