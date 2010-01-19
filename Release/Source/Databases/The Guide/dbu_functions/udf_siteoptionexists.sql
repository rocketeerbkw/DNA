CREATE FUNCTION udf_siteoptionexists (@siteid int, @section varchar(50), @name varchar(50))
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	IF EXISTS(SELECT 1 FROM dbo.SiteOptions WHERE Siteid=@SiteID AND Section=@section AND Name=@name)
	BEGIN
		RETURN 1
	END
RETURN 0
END
