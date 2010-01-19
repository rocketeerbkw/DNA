CREATE PROCEDURE contentsignifincrementarticle 
	@siteid 	INT, 
	@entryid 	INT, 
	@increment	INT
AS
	/* 
		Increases article's significance score by @increment if @nodeid and @increment are not null.
	*/

	DECLARE @ErrorCode INT
	
	
	IF EXISTS(SELECT 1 FROM dbo.ContentSignifArticle WHERE EntryID = @entryid AND SiteID = @SiteID)
	BEGIN
		UPDATE dbo.ContentSignifArticle 
		   SET Score = Score + @increment, 
		       ScoreLastIncrement = getdate()
		 WHERE EntryID = @entryid
		   AND SiteID = @siteid 
		
		SELECT @ErrorCode = @@ERROR

		IF @ErrorCode<>0 GOTO HandleError
	END
	ELSE
	BEGIN
		INSERT INTO dbo.ContentSignifArticle 
		(
			EntryID, 
			Score, 
			SiteID, 
			ScoreLastIncrement, 
			DateCreated
		)
		VALUES 
		(
			@entryid, 
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
