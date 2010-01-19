CREATE PROCEDURE contentsignifincrementclub
	@siteid 	INT, 
	@clubid 	INT, 
	@increment	INT
AS
	/* 
		Increases club's significance score by @increment if @nodeid and @increment are not null.
	*/

	DECLARE @ErrorCode INT


	IF EXISTS(SELECT 1 FROM dbo.ContentSignifClub WHERE ClubID = @clubid AND SiteID = @SiteID)
	BEGIN
		UPDATE dbo.ContentSignifClub 
		   SET Score = Score + @increment, 
		       ScoreLastIncrement = getdate()
		 WHERE ClubId = @clubid 
		   AND SiteID = @siteid 
		
		SELECT @ErrorCode = @@Error

		IF (@ErrorCode <> 0) GOTO HandleError
	END
	ELSE
	BEGIN
		INSERT INTO dbo.ContentSignifClub 
		(
			ClubID, 
			Score, 
			SiteID, 
			ScoreLastIncrement, 
			DateCreated
		)
		VALUES 
		(
			@clubid, 
			@increment, 
			@siteid, 
			getdate(), 
			getdate()
		)
		
		SELECT @ErrorCode = @@Error

		IF (@ErrorCode <> 0) GOTO HandleError
	END

RETURN 0

-- Error Handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode