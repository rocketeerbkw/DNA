-- drop function udf_removegrammaticalarticlesfromtext
CREATE FUNCTION udf_removegrammaticalarticlesfromtext (@text varchar(255))
RETURNS VARCHAR(255)
AS
BEGIN
	DECLARE @str varchar(255)

	SELECT @str = CASE WHEN LEFT(LTRIM(@text),4) = 'the ' THEN LTRIM(SUBSTRING(LTRIM(@text),5,LEN(LTRIM(@text))))
						WHEN LEFT(LTRIM(@text),2) = 'a ' THEN LTRIM(SUBSTRING(LTRIM(@text),3,LEN(LTRIM(@text))))
						WHEN LEFT(LTRIM(@text),1) = '''' THEN LTRIM(SUBSTRING(LTRIM(@text),2,LEN(LTRIM(@text))))
						ELSE LTRIM(@text) END

	RETURN @str
END