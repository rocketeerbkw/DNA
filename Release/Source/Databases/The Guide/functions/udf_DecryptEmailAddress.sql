CREATE FUNCTION udf_decryptemailaddress
(
	@encemailaddress varbinary(300),
	@userid int
)
RETURNS varchar(255)
AS
BEGIN
	RETURN cast(DecryptByKey(@encemailaddress,1,CONVERT(sysname, @userid)) AS varchar(255))
END