CREATE PROCEDURE deletecategorylist @categorylistid uniqueidentifier
AS
DECLARE @Error int, @Description varchar(128), @Deleted int
IF EXISTS ( SELECT * FROM dbo.CategoryList WHERE CategoryListID = @categorylistid )
BEGIN
	SELECT @Description = [Description] FROM dbo.CategoryList WHERE CategoryListID = @categorylistid
	BEGIN TRANSACTION

	DELETE FROM dbo.CategoryList WHERE CategoryListID = @categorylistid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

	DELETE FROM dbo.CategoryListMembers WHERE CategoryListID = @categorylistid
	SELECT @Error = @@ERROR
	if (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

	COMMIT TRANSACTION
	SELECT @Deleted = 1
END
SELECT 'Deleted' = ISNULL(@Deleted,0), 'Description' = @Description
