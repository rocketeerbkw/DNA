CREATE PROCEDURE setusershidelocationflag @userid INT, @hide INT
AS
DECLARE @Error INT

BEGIN TRANSACTION

	-- Set the new value for the users location privicy flag
	IF (@hide > 0)
	BEGIN
		UPDATE dbo.Users SET HideLocation = @hide, Area = NULL WHERE UserID = @UserID
	END
	ELSE
	BEGIN
		UPDATE dbo.Users SET HideLocation = @hide WHERE UserID = @UserID
	END
	SET @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error		
	END

COMMIT TRANSACTION