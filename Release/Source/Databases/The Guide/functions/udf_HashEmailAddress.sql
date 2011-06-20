CREATE FUNCTION udf_hashemailaddress
(
	@emailaddress varchar(255)
)
RETURNS varbinary(900)
AS
BEGIN
	IF @emailaddress IS NULL OR @emailaddress='' OR @emailaddress='0'
		RETURN NULL

	DECLARE @salt varchar(255), @EncryptedSalt varbinary(8000)

	-- Use email encryption key to decript the hash salt
	SELECT @EncryptedSalt=EncryptedSalt FROM Salt WHERE SaltId='Email'
	SELECT @salt=cast(DecryptByKey(@EncryptedSalt) AS varchar(255))
	
	-- Hash the email address, inc. salt
	RETURN HashBytes('SHA1',@salt+@emailaddress)
END