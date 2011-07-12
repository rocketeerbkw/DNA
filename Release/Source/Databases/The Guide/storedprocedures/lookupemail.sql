Create Procedure lookupemail @email varchar(255)
As

EXEC openemailaddresskey

declare @uid int, @exists int
declare @cookie uniqueidentifier, @userid int
declare @checksum int, @active int, @password varchar(255)
SELECT @exists = 0
DECLARE @hashedemail VARBINARY(900)
SET @hashedemail= dbo.udf_hashemailaddress(@email)
IF EXISTS (SELECT * FROM Users WHERE hashedemail = @hashedemail)
BEGIN
	SELECT @userid = UserID, @cookie = Cookie, @active = Active, @password = Password FROM Users WHERE hashedemail = @hashedemail
	IF (@active = 1)
		SELECT @exists = 1
END
EXEC checksumcookie @cookie, @checksum OUTPUT
SELECT 'UserID' = @userid, 'Cookie' = @cookie, 'Checksum' = @checksum, 'Exists' = @exists, 'Password' = @password
	return (0)
