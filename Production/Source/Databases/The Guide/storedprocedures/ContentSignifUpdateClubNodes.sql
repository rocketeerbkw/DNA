CREATE PROCEDURE contentsignifupdateclubnodes
	@itemid		INT, 
	@siteid		INT, 
	@clubid		INT, 
	@value		INT
AS
	/*
		Updates the significance of all nodes associated with a club.
	*/
	DECLARE @NodeID		INT
	DECLARE @ErrorCode	INT

	DECLARE clubhierarchynodes_cursor CURSOR DYNAMIC FOR
	SELECT hier.NodeID
		  FROM Hierarchy AS hier WITH (NOLOCK)
		   INNER JOIN HierarchyClubMembers AS hcm WITH (NOLOCK) ON hcm.NodeID = hier.NodeID
		   INNER JOIN Clubs AS c WITH (NOLOCK) ON c.ClubID = hcm.ClubID
	 WHERE c.ClubID = @clubid

	OPEN clubhierarchynodes_cursor

	FETCH NEXT FROM clubhierarchynodes_cursor
		INTO @NodeID

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXEC @ErrorCode = dbo.contentsignifincrementitem @itemid	= @itemid, 
													  	 @value		= @Value, 
													  	 @siteid 	= @siteid, 
													  	 @nodeid	= @NodeID

		IF @ErrorCode<>0 GOTO HandleError

		FETCH NEXT FROM clubhierarchynodes_cursor
			INTO @NodeID
	END 

	CLOSE clubhierarchynodes_cursor
	DEALLOCATE clubhierarchynodes_cursor

RETURN @@ERROR

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode