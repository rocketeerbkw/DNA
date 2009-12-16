CREATE PROCEDURE startuserprivacyupdate @userid INT, @hidelocation INT = NULL, @hideusername INT = NULL
AS
DECLARE @Error INT

BEGIN TRANSACTION

	IF (@hideusername IS NOT NULL)
		BEGIN
		-- Set the new value for the users username privicy flag
		IF (@hideusername > 0)
		BEGIN
			UPDATE dbo.Users SET HideUserName = @hideusername, FirstNames = NULL, LastName = NULL, UserName = ('U' + CAST(userid AS VARCHAR(255))) WHERE UserID = @userid
		END
		ELSE
		BEGIN
			UPDATE dbo.Users SET HideUserName = @hideusername, UserName = LoginName WHERE UserID = @userid
		END
		SET @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error		
		END
	END

	IF (@hidelocation IS NOT NULL)
	BEGIN
		-- Set the new value for the users location privicy flag
		IF (@hidelocation > 0)
		BEGIN
			UPDATE dbo.Users SET HideLocation = @hidelocation, Area = NULL WHERE UserID = @userid
		END
		ELSE
		BEGIN
			UPDATE dbo.Users SET HideLocation = @hidelocation WHERE UserID = @userid
		END
		SET @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error		
		END
	END
		
COMMIT TRANSACTION