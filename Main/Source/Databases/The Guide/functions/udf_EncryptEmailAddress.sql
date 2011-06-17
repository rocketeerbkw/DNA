CREATE FUNCTION udf_encryptemailaddress
(
	@emailaddress varchar(255),
	@userid int
)
RETURNS varbinary(8000)
AS
BEGIN
	RETURN EncryptByKey(KEY_GUID('key_EmailAddress'),@emailaddress,1, CONVERT( sysname, @userid))
END
