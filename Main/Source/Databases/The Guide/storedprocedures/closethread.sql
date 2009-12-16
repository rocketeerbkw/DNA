CREATE PROCEDURE closethread @threadid int, @hidethread BIT = 0
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
	update Threads Set	CanWrite = 0, 
						CanRead = CASE WHEN @hidethread <> 0 THEN 0 ELSE 1 END, 
						LastUpdated = getdate()
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