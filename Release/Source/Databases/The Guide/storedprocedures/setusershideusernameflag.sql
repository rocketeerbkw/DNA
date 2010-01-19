CREATE PROCEDURE setusershideusernameflag @userid INT, @hide INT
AS
DECLARE @Error INT

BEGIN TRANSACTION

	-- Set the new value for the users username privicy flag
	IF (@hide > 0)
	BEGIN
		UPDATE dbo.Users SET HideUserName = @hide, FirstNames = NULL, LastName = NULL, UserName = ('U' + CAST(userid AS VARCHAR(255))) WHERE UserID = @UserID
	END
	ELSE
	BEGIN
		UPDATE dbo.Users SET HideUserName = @hide WHERE UserID = @UserID
	END
	SET @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error		
	END

COMMIT TRANSACTION