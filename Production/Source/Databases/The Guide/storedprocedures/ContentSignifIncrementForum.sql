CREATE PROCEDURE contentsignifincrementforum
	@siteid 	INT, 
	@forumid 	INT,
	@increment	INT
AS
	/* 
		Increases forum's significance score by @increment if @nodeid and @increment are not null.
	*/

	DECLARE @ErrorCode INT
	
	
	IF EXISTS(SELECT 1 FROM dbo.ContentSignifForum WHERE ForumID = @forumid AND SiteID = @SiteID)
	BEGIN
		UPDATE dbo.ContentSignifForum 
		   SET Score = Score + @increment, 
		       ScoreLastIncrement = getdate()
		 WHERE ForumId = @forumid 
		   AND SiteID = @siteid

		SELECT @ErrorCode = @@ERROR

		IF @ErrorCode<>0 GOTO HandleError
	END
	ELSE
	BEGIN
		INSERT INTO dbo.ContentSignifForum 
		(
			ForumID, 
			Score, 
			SiteID, 
			ScoreLastIncrement, 
			DateCreated
		)
		VALUES 
		(
			@forumid, 
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
