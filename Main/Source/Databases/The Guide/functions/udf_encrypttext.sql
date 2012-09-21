CREATE FUNCTION udf_encrypttext
(
	@text varchar(8000),
	@postid int
)
RETURNS varbinary(8000)
AS
BEGIN
	RETURN EncryptByKey(KEY_GUID('key_EmailAddress'), @text, 1, CONVERT( sysname, @postid))
END