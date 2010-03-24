CREATE PROCEDURE contentsignifdecrementitem
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
		Decrements significance of content item. 
	*/
	DECLARE @ErrorCode 	INT

	IF (@ItemID = 1)
	BEGIN
		-- User
		EXEC @ErrorCode = dbo.contentsignifdecrementuser @siteid	= @siteid, 
														 @userid	= @userid, 
														 @decrement	= @value
	END
	ELSE IF (@ItemID = 2)
	BEGIN 
		-- Article
		EXEC @ErrorCode = dbo.contentsignifdecrementarticle @siteid		= @siteid, 
														 	@entryid	= @entryid, 
														 	@decrement	= @value
	END
	ELSE IF (@ItemID = 3)
	BEGIN 
		-- Node
		EXEC @ErrorCode = dbo.contentsignifdecrementnode @siteid	= @siteid, 
														 @nodeid	= @nodeid, 
														 @decrement	= @value
	END
	ELSE IF (@ItemID = 4)
	BEGIN 
		-- Forum
		EXEC @ErrorCode = dbo.contentsignifdecrementforum @siteid		= @siteid, 
														  @forumid		= @forumid, 
														  @decrement	= @value
	END
	ELSE IF (@ItemID = 5)
	BEGIN 
		-- Club
		EXEC @ErrorCode = dbo.contentsignifdecrementclub @siteid	= @siteid, 
														 @clubid	= @clubid, 
														 @decrement	= @value
	END
	ELSE IF (@ItemID = 6)
	BEGIN 
		-- Thread
		EXEC @ErrorCode = dbo.contentsignifdecrementthread @siteid		= @siteid, 
														   @threadid	= @threadid, 
														   @decrement	= @value
	END

	IF @ErrorCode<>0 GOTO HandleError

RETURN 0 

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode