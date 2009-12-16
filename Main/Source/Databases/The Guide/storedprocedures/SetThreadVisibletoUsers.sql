CREATE PROCEDURE setthreadvisibletousers @threadid int, @forumid int, @visible int
AS
DECLARE @Error int
IF EXISTS ( SELECT ThreadID FROM Threads WHERE ThreadID = @threadid AND ForumID = @forumid )
BEGIN
	BEGIN TRANSACTION

	UPDATE Threads SET	CanRead = @visible, 
						CanWrite = @visible,
						LastUpdated = getdate()
	WHERE ThreadID = @threadid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

--	UPDATE Forums SET LastUpdated = DEFAULT WHERE ForumID = @forumid
	INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
		VALUES(@forumid, getdate())
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

	COMMIT TRANSACTION
	SELECT 'ThreadBelongsToForum' = 1
END
ELSE
	SELECT 'ThreadBelongsToForum' = 0