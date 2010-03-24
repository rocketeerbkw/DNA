/* findcookie
In: @cookie - GUID to search for
Result: UserID - integer index for record
Cookie - as sent in
email - email address
Username - user supplied username
Password - user's password
FirstNames
LastName
Active - 0 for not active, 1 for active

Search the database for a cookie and return the relevant record

*/
CREATE  PROCEDURE findcookie @cookie uniqueidentifier, @siteid int = 1
AS
declare @userid int
SELECT @userid = UserID FROM Users WITH(NOLOCK) WHERE Cookie = @cookie AND Status <> 0
IF @userid IS NULL
BEGIN
	SELECT 'UserID' = 0
END
ELSE
BEGIN
	EXEC finduserfromid @userid, NULL, @siteid	
END


