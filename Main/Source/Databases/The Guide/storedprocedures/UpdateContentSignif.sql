CREATE PROCEDURE updatecontentsignif 
	@activitydesc	VARCHAR(255), 
	@siteid 		INT, 
	@nodeid			INT	= NULL, 
	@entryid		INT	= NULL, 
	@userid			INT	= NULL, 
	@clubid			INT	= NULL, 
	@threadid		INT	= NULL, 
	@forumid		INT	= NULL
AS
	DECLARE @ErrorCode 	INT
	DECLARE @ActionID	INT	
	DECLARE @ItemID		INT
	DECLARE @Value		INT
	DECLARE @Type		char

	-- Get Action's ID.
	EXEC @ErrorCode = dbo.getcontentsignifactionid	@actiondesc	= @activitydesc, 
											   		@actionid	= @ActionID OUTPUT

	IF (@ErrorCode <> 0) GOTO HandleError

	IF (@ActionID IS NULL)
	BEGIN
		-- Action significance is not registered for this action. Return without error. 
		RETURN 0
	END 

	-- Cursor round content items to be increment and decrement for this action.
	DECLARE itemtoupdate_cursor CURSOR DYNAMIC FOR
	SELECT incr.ItemID, 
		   incr.Value, 
		   'i' 
	  FROM ContentSignifAction AS act WITH (NOLOCK)
		   INNER JOIN ContentSignifIncrement AS incr WITH (NOLOCK) ON act.ActionID = incr.ActionID
	 WHERE act.ActionID = @ActionID
	   AND incr.SiteID	= @siteid
 	 UNION ALL 
	SELECT decr.ItemID, 
		   decr.Value,
		   'd'
	  FROM ContentSignifAction AS act WITH (NOLOCK)
		   INNER JOIN ContentSignifDecrement AS decr WITH (NOLOCK) ON act.ActionID = decr.ActionID
	 WHERE act.ActionID = @ActionID
	   AND decr.SiteID	= @siteid

	OPEN itemtoupdate_cursor 

	FETCH NEXT FROM itemtoupdate_cursor 
		INTO @ItemID, @Value, @Type

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF (@Type = 'i')
		BEGIN
			IF (@ItemID = 3)
			BEGIN
				-- 	Item: Node. Exceptions to to normal processing must be made because action can impact multiple instances of the same type of item. 
				IF (@ActionID = 7)
				BEGIN
					-- Action: UpdateGuideEntry
					EXEC @ErrorCode = dbo.contentsignifupdateguideentrynodes @siteid	= @siteid, 
																			 @itemID	= @ItemID, 
																			 @entryid	= @entryid, 
																			 @value		= @Value
				END
				ELSE IF (@ActionID = 6)
				BEGIN
					-- Action: PostToForum
					EXEC @ErrorCode = dbo.contentsignifupdateforumnodes @siteid 	= @siteid, 
																		@itemID 	= @ItemID, 
																		@forumid 	= @forumid, 
																		@value		= @Value
				END
				ELSE
				BEGIN
					-- Just update the node passed in. 
					EXEC @ErrorCode = dbo.contentsignifincrementitem @itemid	= @ItemID, 
																     @value		= @Value, 
																     @siteid 	= @siteid, 
																     @nodeid	= @nodeid 
				END
			END
			ELSE IF (@ItemID = 1 AND @ActionID = 10)
			BEGIN
				-- User's significance needs to be incremented across all sites interested in this aciton.
				EXEC @ErrorCode = dbo.contentsignifincrementusersubscribe @userid = @UserID
			END
			ELSE IF (@ItemID = 1 AND @ActionID = 11)
			BEGIN
				-- All the Page Authors significance need to be incremented in this action.
				EXEC @ErrorCode = dbo.contentsignifincrementpageauthors @entryid	= @entryid, 
																		@siteid 	= @siteid, 
																		@increment	= @Value
			END
			ELSE 
			BEGIN
				-- Increment item's significance.
				EXEC @ErrorCode = dbo.contentsignifincrementitem @itemid	= @ItemID, 
															     @value		= @Value, 
															     @siteid 	= @siteid, 
															     @nodeid	= @nodeid, 
															     @entryid	= @entryid, 
															     @userid	= @userid, 
															     @clubid	= @clubid, 
															     @threadid	= @threadid,
															     @forumid	= @forumid
			END
		END 
		ELSE IF (@Type = 'd')
		BEGIN 
			-- Decrement item's significance.
			EXEC @ErrorCode = dbo.contentsignifdecrementitem @itemid	= @ItemID, 
														  	 @value		= @Value, 
														  	 @siteid 	= @siteid, 
														  	 @nodeid	= @nodeid, 
														  	 @entryid	= @entryid, 
														  	 @userid	= @userid, 
														  	 @clubid	= @clubid, 
														  	 @threadid	= @threadid,
														  	 @forumid	= @forumid
		END 

		IF @ErrorCode<>0 GOTO HandleError

		FETCH NEXT FROM itemtoupdate_cursor 
			INTO @ItemID, @Value, @Type
	END 

	CLOSE itemtoupdate_cursor 
	DEALLOCATE itemtoupdate_cursor 
	
RETURN 0 

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode