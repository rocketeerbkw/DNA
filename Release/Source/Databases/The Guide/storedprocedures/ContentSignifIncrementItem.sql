CREATE PROCEDURE contentsignifincrementitem 
	@itemid		INT, 
	@siteid 	INT, 
	@value		INT, 
	@nodeid		INT = NULL, 
	@entryid	INT = NULL, 
	@userid		INT = NULL, 
	@clubid		INT = NULL, 
	@threadid	INT = NULL,
	@forumid	INT = NULL
AS
	/*
		Increments significance of content item. 
	*/
	DECLARE @ErrorCode 	INT

	IF (@ItemID = 1 AND @userid IS NOT NULL)
	BEGIN
		-- User
		EXEC @ErrorCode = dbo.contentsignifincrementuser @siteid	= @siteid, 
														 @userid	= @userid, 
														 @increment	= @value
	END
	ELSE IF (@ItemID = 2 AND @entryid IS NOT NULL)
	BEGIN 
		-- Article
		EXEC @ErrorCode = dbo.contentsignifincrementarticle @siteid		= @siteid, 
														 	@entryid	= @entryid, 
														 	@increment	= @value
	END
	ELSE IF (@ItemID = 3 AND @nodeid IS NOT NULL)
	BEGIN 
		-- Node
		EXEC @ErrorCode = dbo.contentsignifincrementnode @siteid	= @siteid, 
														 @nodeid	= @nodeid, 
														 @increment	= @value
	END
	ELSE IF (@ItemID = 4 AND @forumid IS NOT NULL)
	BEGIN 
		-- Forum
		EXEC @ErrorCode = dbo.contentsignifincrementforum @siteid		= @siteid, 
														  @forumid		= @forumid, 
														  @increment	= @value
	END
	ELSE IF (@ItemID = 5 AND @clubid IS NOT NULL)
	BEGIN 
		-- Club
		EXEC @ErrorCode = dbo.contentsignifincrementclub @siteid	= @siteid, 
														 @clubid	= @clubid, 
														 @increment	= @value
	END
	ELSE IF (@ItemID = 6 AND @threadid IS NOT NULL)
	BEGIN 
		-- Thread
		EXEC @ErrorCode = dbo.contentsignifincrementthread @siteid		= @siteid, 
														   @threadid	= @threadid, 
														   @increment	= @value
	END

	IF @ErrorCode<>0 GOTO HandleError

RETURN 0 

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode