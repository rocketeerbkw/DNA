CREATE PROCEDURE contentsignifupdateguideentrynodes
	@itemid		INT, 
	@siteid		INT, 
	@entryid	INT, 
	@value		INT
AS

	/*
		Updates the significance of all nodes associated with a Guide Entry.
	*/
	DECLARE @NodeID		INT
	DECLARE @ErrorCode	INT

	DECLARE guideentryhierarchynodes_cursor CURSOR DYNAMIC FOR
	SELECT hier.NodeID
		  FROM Hierarchy AS hier WITH (NOLOCK)
		   INNER JOIN HierarchyArticleMembers AS ham WITH (NOLOCK) ON ham.NodeID = hier.NodeID
		   INNER JOIN GuideEntries AS ge WITH (NOLOCK) ON ge.EntryID = ham.EntryID
	 WHERE ge.EntryID = @entryid

	OPEN guideentryhierarchynodes_cursor

	FETCH NEXT FROM guideentryhierarchynodes_cursor
		INTO @NodeID

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXEC @ErrorCode = dbo.contentsignifincrementitem @itemid	= @itemid, 
													  	 @value		= @Value, 
													  	 @siteid 	= @siteid, 
													  	 @nodeid	= @NodeID

		IF @ErrorCode<>0 GOTO HandleError

		FETCH NEXT FROM guideentryhierarchynodes_cursor
			INTO @NodeID
	END 

	CLOSE guideentryhierarchynodes_cursor
	DEALLOCATE guideentryhierarchynodes_cursor

RETURN @@ERROR

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode