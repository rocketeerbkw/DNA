CREATE PROCEDURE registerlocaluser @loginname varchar(255), @password varchar(255), @email varchar(255)
as
declare @userid int
declare @curpassword varchar(255)
SELECT @userid = userID , @curpassword = Password FROM Users WHERE LoginName = @loginname
DECLARE @ErrorCode INT

IF (@userid IS NOT NULL)
BEGIN
	IF (@curpassword = @password)
	BEGIN
		select UserID, LoginName, Cookie, BBCUID FROM Users WHERE UserID = @userid
	END
	ELSE
	BEGIN
		select 'ErrorCode' = 1, 'Reason' = 'badpassword'
	END
END
ELSE
BEGIN
	BEGIN TRANSACTION
	
	EXEC openemailaddresskey
		
	INSERT INTO Users (LoginName, UserName, Password, Active, Status, BBCUID)
	VALUES(@loginname, @loginname, @password, 1, 1, newid())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	SELECT @userid = SCOPE_IDENTITY()
	
	UPDATE Users
		SET EncryptedEmail = dbo.udf_encryptemailaddress(@email,UserId),
			HashedEmail = dbo.udf_hashemailaddress(@email)
		WHERE UserId = @userid
	
	COMMIT TRANSACTION
	SELECT UserID, LoginName, Cookie, BBCUID FROM Users WHERE UserID = @userid
END