CREATE PROCEDURE setcategorylistwidth @categorylistid UNIQUEIDENTIFIER, @listwidth INT
AS
	IF EXISTS (SELECT 1
				 FROM dbo.CategoryList 
				WHERE CategoryListID = @categorylistid)
	BEGIN
		BEGIN TRANSACTION

		DECLARE @Error INT

		UPDATE dbo.CategoryList 
		   SET ListWidth = @listwidth
		 WHERE CategoryListID = @categorylistid

		SELECT @Error = @@ERROR
	
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	END
	ELSE
	BEGIN
		--  No match on @categorylistid	
		RETURN 1
	END 

COMMIT TRANSACTION 

SELECT CategoryListID, Description, ListWidth
  FROM dbo.CategoryList
 WHERE CategoryListID = @categorylistid

RETURN 0
