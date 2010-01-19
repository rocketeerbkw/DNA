CREATE PROCEDURE contentsignifincrementnode
	@siteid 	INT, 
	@nodeid 	INT, 
	@increment	INT
AS
	/* 
		Increases node's significance score by @increment if @nodeid and @increment are not null.
	*/

	DECLARE @ErrorCode INT

	
	IF EXISTS(SELECT 1 FROM dbo.ContentSignifNode WHERE NodeID = @nodeid AND SiteID = @SiteID)
	BEGIN
		UPDATE dbo.ContentSignifNode 
		   SET Score = Score + @increment, 
		       ScoreLastIncrement = getdate()
		 WHERE NodeId = @nodeid 
		   AND SiteID = @siteid 

		SELECT @ErrorCode = @@Error
		
		IF @ErrorCode<>0 GOTO HandleError
	END
	ELSE
	BEGIN
		INSERT INTO dbo.ContentSignifNode 
		(
			NodeID, 
			Score, 
			SiteID, 
			ScoreLastIncrement, 
			DateCreated
		)
		VALUES 
		(
			@nodeid, 
			@increment, 
			@siteid, 
			getdate(), 
			getdate()
		)
		
		SELECT @ErrorCode = @@Error

		IF @ErrorCode<>0 GOTO HandleError 
	END

RETURN 0

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode