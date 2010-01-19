CREATE PROCEDURE findbbcuid	@bbcuid uniqueidentifier, @siteid int
As
declare @userid int, @cookie uniqueidentifier
SELECT @userid = UserID, @cookie = Cookie FROM Users WHERE BBCUID = @bbcuid
IF @userid IS NOT NULL
BEGIN
	EXEC populateuseraccount @userid, @siteid
	SELECT 'UserID' = @userid, 'Cookie' = @cookie
END
