CREATE PROCEDURE createnewuserwithbbcuid	@loginname varchar(255),
											@bbcuid uniqueidentifier,
											@email varchar(255),
											@siteid int = 1
As

	RAISERROR ('createnewuserwithbbcuid no longer used',16,1)
	RETURN	
/*
declare @userid int, @cookie uniqueidentifier
-- create the new account
IF NOT EXISTS (SELECT * FROM Users WHERE BBCUID = @bbcuid)
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	INSERT INTO Users (LoginName, BBCUID, Active)
		VALUES(@loginname, @bbcuid, 1)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	SELECT @userid = SCOPE_IDENTITY()
	
	BEGIN TRY
		EXEC openemailaddresskey

		UPDATE Users 
			SET UserName = 'Researcher ' + CAST(@userid AS varchar),
				EncryptedEmail = dbo.udf_encryptemailaddress(@email,@userid)
			WHERE UserID = @userid
	END TRY
	BEGIN CATCH
		SELECT @ErrorCode = ERROR_NUMBER()
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END CATCH

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
*/
