CREATE PROCEDURE contentsignifincrementuser 
	@siteid 	INT, 
	@userid 	INT,
	@increment 	INT
AS
	/* 
		Increases user's significance score by @increment if @nodeid and @increment are not null.
	*/

	DECLARE @ErrorCode INT

	
	IF EXISTS(SELECT * FROM dbo.ContentSignifUser WHERE UserId = @userid AND SiteID = @SiteID)
	BEGIN
		UPDATE dbo.ContentSignifUser 
		   SET Score = Score + @increment, 
		       ScoreLastIncrement = getdate()
		WHERE UserID = @userid 
		  AND SiteID = @siteid

		SELECT @ErrorCode = @@ERROR 

		IF @ErrorCode<>0 GOTO HandleError
	END
	ELSE
	BEGIN
		INSERT INTO dbo.ContentSignifUser 
		(
			UserID, 
			Score, 
			SiteID, 
			ScoreLastIncrement, 
			DateCreated
		)
		VALUES 
		(
			@userid, 
			@increment, 
			@siteid, 
			getdate(), 
			getdate()
		)
		
		SELECT @ErrorCode = @@ERROR 

		IF @ErrorCode<>0 GOTO HandleError
	END

RETURN 0 

-- Error Handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode
