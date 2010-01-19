CREATE PROCEDURE associatewithbbc	@email varchar(255), -- email address in h2g2 user table
										@bbcuid uniqueidentifier, -- BBC-generated UID
										@password varchar(255), -- h2g2 password
										@loginname varchar(255) -- BBC loginname
As
declare @userid int, @cookie uniqueidentifier, @existinguid uniqueidentifier

SELECT @userid = UserID, @cookie = Cookie, @existinguid = BBCUID FROM Users
	WHERE email = @email AND Password = @password

IF @userid IS NULL
BEGIN
	SELECT 'UserID' = NULL, 'Cookie' = NULL, 'Error' = 1, 'Reason' = 'Your email address or your password was mistyped'
END
ELSE
BEGIN 
	IF @existinguid IS NOT NULL AND @existinguid <> @bbcuid
	BEGIN
		SELECT 'UserID' = NULL, 'Cookie' = NULL, 'Error' = 2, 'Reason' = 'That h2g2 identity already has a BBC id'
	END
	ELSE IF EXISTS (SELECT * FROM Users WHERE LoginName = @loginname)
	BEGIN
		SELECT 'UserID' = NULL, 'Cookie' = NULL, 'Error' = 3, 'Reason' = 'That BBC login is already used'
	END
	ELSE
	BEGIN
		-- OK, let's do it
		UPDATE Users SET BBCUID = @bbcuid, LoginName = @loginname
			WHERE userID = @userid
		SELECT 'UserID' = @userid, 'Cookie' = @cookie, 'Error' = 0, 'Reason' = '', 'FirstTime' = CASE WHEN @existinguid IS NULL THEN 1 ELSE 0 END
	END
END