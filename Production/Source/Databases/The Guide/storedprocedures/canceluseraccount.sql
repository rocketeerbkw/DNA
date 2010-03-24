/*
	canceluseraccount

	Returns: 'Result' = 0/1/2 etc, 'Reason' = 'Reason for failure'
	This new stored procedure will first check that the key passed 
	matches the cookie in the user account (using checksumcookie). 
	If these don't match, this will fail. If they do match, change 
	the following in the user record:
	·	Cookie = newid()
	·	Password = NULL
	·	Email = NULL
	·	Active = 0

	The following result codes are returned:
	·	0 - Account cancelled
	·	1 - No such account
	·	2 - key did not match cookie

*/
CREATE PROCEDURE canceluseraccount @userid int, @key int
As

declare @checksum int, @cookie uniqueidentifier, @email varchar(255)
declare @result int, @reason varchar(255)
-- Get the cookie from the database
SELECT @cookie = Cookie, @email = email FROM Users WHERE UserID = @userid
IF @cookie IS NULL
BEGIN
	SELECT @result = 1, @reason = 'The user does not exist'
END
ELSE
BEGIN
	EXEC checksumcookie @cookie, @checksum OUTPUT
	IF @checksum <> @key
	BEGIN
		IF @email IS NULL
		BEGIN
			SELECT @result = 3, @reason = 'The account has already been cancelled'
		END
		ELSE
		BEGIN
			SELECT @result = 2, @reason = 'The key was incorrect'
		END
	END
	ELSE
	BEGIN
		UPDATE Users
			SET Active = 0, email = NULL, Password = NULL, Cookie = newid()
			WHERE UserID = @userid
		SELECT @result = 0
	END
END

SELECT 'Result' = @result, 'Reason' = @reason

return (0)