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
		INSERT INTO Users (LoginName, UserName, Email, Password, Active, Status, BBCUID)
	VALUES(@loginname, @loginname, @email, @password, 1, 1, newid())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	SELECT @userid = @@IDENTITY
	COMMIT TRANSACTION
	SELECT UserID, LoginName, Cookie, BBCUID FROM Users WHERE UserID = @userid
END