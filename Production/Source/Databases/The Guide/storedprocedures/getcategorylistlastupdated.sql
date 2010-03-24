CREATE PROCEDURE getcategorylistlastupdated @categorylistid uniqueidentifier
AS
	SELECT cl.LastUpdated
	  FROM dbo.CategoryList AS cl WITH (NOLOCK)
	 WHERE cl.CategoryListID = @categorylistid

RETURN 0