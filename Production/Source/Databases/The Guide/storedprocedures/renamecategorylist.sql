CREATE PROCEDURE renamecategorylist @categorylistid uniqueidentifier, @description varchar(128)
AS
DECLARE @Error int
BEGIN TRANSACTION
	UPDATE dbo.CategoryList SET Description = @description WHERE CategoryListID = @categorylistid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
COMMIT TRANSACTION