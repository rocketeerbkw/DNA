CREATE   PROCEDURE storeemailforlist @email varchar(255), @listid int
AS
RAISERROR('storeemailforlist DEPRECATED',16,1)

/*
	Deprecated - no longer called

DECLARE @uid int
IF EXISTS (SELECT * FROM Users WHERE email = @email)
BEGIN
	SELECT 'Success' = 0
END
ELSE
BEGIN
	BEGIN TRANSACTION
	DECLARE @ErrorCode INT

	INSERT INTO Users (email) VALUES (@email)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END
	SELECT @uid = @@IDENTITY

	INSERT INTO Membership (ListID, UserID) VALUES (@listid, @uid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0
		RETURN @ErrorCode
	END

	COMMIT TRANSACTION

	SELECT 'Success' = 1
END

*/