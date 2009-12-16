CREATE PROCEDURE deletecategorylistmember @categorylistid uniqueidentifier, @nodeid int
AS
DECLARE @Error int, @Deleted int
IF EXISTS ( SELECT * FROM dbo.CategoryListMembers WHERE CategoryListID = @categorylistid AND NodeID = @nodeid)
BEGIN
	BEGIN TRANSACTION
		-- Remove the selected member from the members list
		DELETE FROM dbo.CategoryListMembers WHERE CategoryListID = @categorylistid AND NodeID = @nodeid
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
		
		-- Update the category lists last update value
		UPDATE dbo.CategoryList SET LastUpdated = GetDate() WHERE CategoryListID = @categorylistid
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	COMMIT TRANSACTION
	
	SET @Deleted = 1
END
SELECT 'Deleted' = ISNULL(@Deleted,0)
