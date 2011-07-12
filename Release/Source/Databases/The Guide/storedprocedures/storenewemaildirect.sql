CREATE PROCEDURE storenewemaildirect @email varchar(255)
AS
RAISERROR('storenewemaildirect DEPRECATED',16,1)

/* storenewemail
In: @email - email address
Result: Cookie - GUID for this new user
UserID - integer user ID (index into table)

Given only an email address, creates a new user record and returns a cookie, 
a cookie checksum and a UID.

*/

/*
	Deprecated - never called
	
declare @uid int
INSERT INTO Users (email) VALUES (@email)

RETURN @@ERROR
*/