Create Procedure unsubscribefromjournalthread @userid int, @threadid int, @forumid int
as
IF NOT EXISTS (SELECT * FROM Users WHERE UserID = @userid AND Journal = @forumid)
BEGIN
	-- don't let them unsubscribe from journal threads
	SELECT 'Result' = 2, 'Reason' = 'You can''t unsubscribe from another person''s Journal'
END
ELSE
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	DELETE FROM ThreadPostings
		WHERE UserID = @userid AND ThreadID = @threadid AND ForumID = @forumid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Result' = 1, 'Reason' = 'Internal error'
		RETURN @ErrorCode
	END

--	UPDATE Forums SET LastUpdated = getdate() WHERE ForumID = @forumid
	INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
		VALUES(@forumid, getdate())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Result' = 1, 'Reason' = 'Internal error'
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION

	SELECT 'Result' = 0
END