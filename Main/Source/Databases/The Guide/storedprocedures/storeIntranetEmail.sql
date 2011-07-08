/* storeintranetemail
In: @email - email address
Result: Cookie - GUID for this new user
UserID - integer user ID (index into table)
Checksum - numeric checksum for the cookie
Exists - 0 or 1 indicating user was new or already existed

Given only an email address, locates the next free user record and returns a cookie, a cookie checksum and a UID.
*/

CREATE   PROCEDURE storeintranetemail @email varchar(255)
AS
RAISERROR('storeintranetemail DEPRECATED',16,1)

/*
	Deprecated - no longer called
	
declare @uid int, @exists int
declare @cookie uniqueidentifier, @userid int
declare @checksum int, @active int
SELECT @exists = 0
IF EXISTS (SELECT * FROM Users WHERE email = @email)
BEGIN
	SELECT @userid = UserID, @cookie = Cookie, @active = Active FROM Users WHERE email = @email
	SELECT @exists = 1
END
ELSE
BEGIN
	SELECT top 1 @cookie=Cookie, @userid=userid FROM Users WHERE (UserID>250) AND (UserID<10000) AND (email is NULL) AND (Active=0) ORDER BY UserID
	UPDATE Users SET email = @email WHERE UserID = @userid

END
EXEC checksumcookie @cookie, @checksum OUTPUT
SELECT 'UserID' = @userid, 'Cookie' = @cookie, 'Checksum' = @checksum, 'Exists' = @exists, 'Worked' = 1

*/