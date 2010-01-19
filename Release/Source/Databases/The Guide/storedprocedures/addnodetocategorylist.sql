CREATE PROCEDURE addnodetocategorylist @categorylistid uniqueidentifier, @nodeid INT
AS
IF NOT EXISTS ( SELECT * FROM dbo.CategoryListMembers WHERE CategoryListID = @categorylistid AND NodeID = @nodeid )
BEGIN
	DECLARE @Error 		INT
	DECLARE @allowed	INT

	EXEC @Error = dbo.checkcategorylistaddnodewithintaglimits @categorylistid 	= @categorylistid,
														   	  @nodeid			= @nodeid, 
														      @allowed		 	= @allowed OUTPUT

	IF (@allowed != 1)
	BEGIN
		EXEC Error @Error
		RETURN 0
	END

	BEGIN TRANSACTION
		-- Insert the new item into the table
		INSERT INTO dbo.CategoryListMembers (CategoryListID,NodeID) VALUES (@categorylistid,@nodeid)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
		
		-- Update category lists last updated value.
		UPDATE dbo.CategoryList SET LastUpdated = GetDate() WHERE CategoryListID = @categorylistid
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	COMMIT TRANSACTION
END
