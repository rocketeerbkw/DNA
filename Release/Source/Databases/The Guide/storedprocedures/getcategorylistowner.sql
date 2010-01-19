CREATE PROCEDURE getcategorylistowner @categorylistid uniqueidentifier
AS
BEGIN
	SELECT UserID FROM dbo.CategoryList WHERE CategoryListID = @categorylistid
END