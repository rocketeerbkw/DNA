Create Procedure setprefforumstyle	@userid int, @newvalue tinyint
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

IF NOT EXISTS (SELECT * FROM Preferences WITH(UPDLOCK) WHERE UserID = @userid)
BEGIN
	INSERT INTO Preferences (UserID) VALUES(@userid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

UPDATE Preferences SET PrefForumStyle = @newvalue WHERE UserID = @userid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)