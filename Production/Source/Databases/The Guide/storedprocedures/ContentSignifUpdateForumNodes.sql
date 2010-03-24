CREATE PROCEDURE contentsignifupdateforumnodes
	@itemid		INT, 
	@siteid		INT, 
	@forumid	INT, 
	@value		INT
AS
	/*
		Updates the significance of all nodes associated with a Forum. 
		Calls appropriate update sp depending on the type of content Forum is associate with. 
	*/

	DECLARE @ClubID				INT
	DECLARE @EntryID			INT
	DECLARE @ErrorCode			INT

	SELECT @ClubID = c.ClubID
	  FROM dbo.Clubs AS c WITH (NOLOCK)
		   INNER JOIN dbo.Forums AS f WITH (NOLOCK) ON f.ForumID = c.Journal
	 WHERE f.ForumID = @ForumID

	SELECT @EntryID = ge.EntryID
	  FROM dbo.GuideEntries AS ge WITH (NOLOCK)
		   INNER JOIN dbo.Forums AS f WITH (NOLOCK) ON f.ForumID = ge.ForumID
	 WHERE f.ForumID = @ForumID

	IF (@EntryID IS NOT NULL)
	BEGIN
		EXEC @ErrorCode = dbo.contentsignifupdateguideentrynodes @itemid	= @itemid, 
																 @siteid	= @siteid, 
																 @entryid	= @EntryID, 
																 @value		= @value
	END
	ELSE IF (@ClubID IS NOT NULL)
	BEGIN
		EXEC @ErrorCode = dbo.contentsignifupdateclubnodes @itemid	= @itemid, 
														   @siteid	= @siteid, 
														   @clubid	= @ClubID, 
														   @value	= @value
	END

RETURN @@ERROR

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode