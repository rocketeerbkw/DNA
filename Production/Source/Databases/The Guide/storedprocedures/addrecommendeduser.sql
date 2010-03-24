Create Procedure addrecommendeduser @userid int, @newuser int
As
declare @group int
SELECT @group = Recommended FROM Users WHERE UserID = @userid

BEGIN TRANSACTION
DECLARE @ErrorCode INT

IF @group IS NULL
BEGIN
	INSERT INTO Groups (Name, Owner, System, UserInfo)
		VALUES('Recommended', @userid, 1, 0)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	SELECT @group = @@IDENTITY
	UPDATE Users SET Recommended = @group WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

-- Now insert this user as a member of that group
INSERT INTO GroupMembers (UserID, GroupID)
	VALUES(@newuser, @group)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
