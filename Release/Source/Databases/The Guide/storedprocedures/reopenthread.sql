CREATE PROCEDURE reopenthread @threadid int
as
DECLARE @ErrorCode 	INT
declare @forumid int

BEGIN TRANSACTION

select @forumid = ForumID from Threads WITH(UPDLOCK) where ThreadID = @threadid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

if @forumid IS NOT NULL
BEGIN
	update Threads Set CanRead = 1, CanWrite = 1, VisibleTo = NULL, LastUpdated = getdate()
		WHERE ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

	insert into ForumLastUpdated (ForumID, LastUpdated)
		values(@forumid, getdate())
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END


END
COMMIT TRANSACTION