CREATE FUNCTION udf_decrypttext
(
	@text varbinary(8000),
	@postid int
)
RETURNS varchar(8000)
AS
BEGIN
	RETURN cast(DecryptByKey(@text, 1, CONVERT(sysname, @postid)) AS varchar(8000))
END