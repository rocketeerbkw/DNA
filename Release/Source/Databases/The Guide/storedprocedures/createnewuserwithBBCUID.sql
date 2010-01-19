CREATE PROCEDURE createnewuserwithbbcuid	@loginname varchar(255),
											@bbcuid uniqueidentifier,
											@email varchar(255),
											@siteid int = 1
As
declare @userid int, @cookie uniqueidentifier
-- create the new account
IF NOT EXISTS (SELECT * FROM Users WHERE BBCUID = @bbcuid)
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	INSERT INTO Users (LoginName, BBCUID, email, Active)
		VALUES(@loginname, @bbcuid, @email, 1)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	SELECT @userid = @@IDENTITY

	UPDATE Users SET UserName = 'Researcher ' + CAST(@userid AS varchar) 
		WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	--INSERT INTO Preferences (UserID) VALUES(@userid)
	EXEC @ErrorCode = setdefaultpreferencesforuser @userid
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	EXEC @ErrorCode = populateuseraccount @userid, @siteid
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	COMMIT TRANSACTION

	SELECT Cookie, UserID From Users WHERE UserID = @userid
END
