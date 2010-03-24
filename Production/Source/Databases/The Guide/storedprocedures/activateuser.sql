CREATE    PROCEDURE activateuser @testchecksum int, @userid int 
AS
declare @cookie uniqueidentifier, @active int, @sinbin int
SELECT @cookie = Cookie, @active = Active, @sinbin = SinBin FROM Users WHERE UserID = @userid
declare @checksum int
IF @sinbin IS NULL
BEGIN
	BEGIN TRANSACTION 
	DECLARE @ErrorCode INT

	IF @active = 0
	BEGIN
		INSERT INTO ActivityLog (LogDate, UserID, LogType) VALUES (getdate(), @userid, 'ACTI')
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END

	EXEC @ErrorCode = checksumcookie @cookie, @checksum OUTPUT
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	IF (@checksum = @testchecksum)
	BEGIN
		UPDATE Users WITH(HOLDLOCK) SET Active = 1 WHERE UserID = @userid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		UPDATE Users SET Username = 'Researcher ' + CAST(@userid AS varchar(50)) WHERE UserID = @userid AND UserName IS NULL
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		SELECT UserID, Cookie, 'bAlreadyActive' = @active FROM Users WHERE UserID = @userid
	END

	COMMIT TRANSACTION
END
/*
ELSE
BEGIN
	 INSERT INTO ActivityLog (LogDate, UserID, LogType) VALUES (getdate(), @userid, 'SINA')
END
*/