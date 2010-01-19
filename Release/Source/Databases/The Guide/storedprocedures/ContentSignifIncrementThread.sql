CREATE PROCEDURE contentsignifincrementthread
	@siteid 	INT, 
	@threadid 	INT, 
	@increment	INT
AS
	/* 
		Increases thread's significance score by @increment if @nodeid and @increment are not null.
	*/

	DECLARE @ErrorCode INT

	
	IF EXISTS(SELECT 1 FROM dbo.ContentSignifThread WHERE ThreadID = @threadid AND SiteID = @SiteID)
	BEGIN
		UPDATE dbo.ContentSignifThread 
		   SET Score = Score + @increment, 
		       ScoreLastIncrement = getdate()
		 WHERE ThreadId = @threadid 
		   AND SiteID = @siteid 

		SELECT @ErrorCode = @@Error

		IF @ErrorCode<>0 GOTO HandleError
	END
	ELSE
	BEGIN
		INSERT INTO dbo.ContentSignifThread 
		(
			ThreadID, 
			Score, 
			SiteID, 
			ScoreLastIncrement, 
			DateCreated
		)
		VALUES 
		(
			@threadid, 
			@increment, 
			@siteid, 
			getdate(), 
			getdate()
		)
		
		SELECT @ErrorCode = @@Error

		IF @ErrorCode<>0 GOTO HandleError
	END

RETURN 0

-- Error Handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode
