/* storenewemail
In: @email - email address
Result: Cookie - GUID for this new user
UserID - integer user ID (index into table)
Checksum - numeric checksum for the cookie
Exists - 0 or 1 indicating user was new or already existed

Given only an email address, creates a new user record and returns a cookie, 
a cookie checksum and a UID.

*/
CREATE   PROCEDURE storenewemailold @email varchar(255)
AS
RAISERROR('storenewemailold DEPRECATED',16,1)

/*
	Deprecated - never called

declare @uid int, @exists int
declare @cookie uniqueidentifier, @userid int
declare @checksum int, @active int
SELECT @exists = 0
IF EXISTS (SELECT * FROM Users WHERE email = @email)
BEGIN
	SELECT @userid = UserID, @cookie = Cookie, @active = Active FROM Users WHERE email = @email
	IF (@active = 1)
		SELECT @exists = 1
END
ELSE
BEGIN
	INSERT INTO Users (email) VALUES (@email)
	SELECT @uid = @@IDENTITY
	SELECT @cookie = Cookie, @userid = UserID From Users WHERE UserID = @uid
END
EXEC checksumcookie @cookie, @checksum OUTPUT
SELECT 'UserID' = @userid, 'Cookie' = @cookie, 'Checksum' = @checksum, 'Exists' = @exists

*/