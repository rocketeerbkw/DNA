Create Procedure getregistrationkey @userid int
As
declare @cookie uniqueidentifier, @checksum int

SELECT @cookie = Cookie FROM Users WHERE UserID = @userid
IF @cookie IS NOT NULL
BEGIN
	EXEC checksumcookie @cookie, @checksum OUTPUT
	SELECT 'key' = @checksum
END

	return (0)