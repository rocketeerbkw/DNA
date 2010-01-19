CREATE PROCEDURE updateforumpermissions	@forumid int,
											@canread int=null,
											@canwrite int=null,
											@threadcanread int=null,
											@threadcanwrite int=null
as

BEGIN TRANSACTION
DECLARE @ErrorCode INT

UPDATE Forums SET	LastUpdated = getdate(),
					CanRead = CASE WHEN @canread IS NULL THEN CanRead ELSE @canread END,
					CanWrite = CASE WHEN @canwrite IS NULL THEN CanWrite ELSE @canwrite END,
					ThreadCanRead = CASE WHEN @threadcanread IS NULL THEN ThreadCanRead ELSE @threadcanread END,
					ThreadCanWrite = CASE WHEN @threadcanwrite IS NULL THEN ThreadCanWrite ELSE @threadcanwrite END
				WHERE ForumID = @forumid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
		VALUES(@forumid, getdate())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

COMMIT TRANSACTION