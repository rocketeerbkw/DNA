CREATE PROCEDURE getnumberofnodescategorylististaggedto @categorylistid UNIQUEIDENTIFIER, @nodetypeid INT, @numberofnodescategorylististaggedto INT OUTPUT
AS
	/*
		Outputs the number of nodes, of a certain type (e.g. Issue - see table HierarchyNodeTypes)	
		the category list is tagged to. 
	*/

	DECLARE @ErrorCode	INT

	SELECT @NumberOfNodesCategoryListIsTaggedTo = COUNT(clm.NodeID)
	  FROM dbo.CategoryListMembers clm
		   INNER JOIN dbo.Hierarchy h on h.NodeID = clm.NodeID
	 WHERE clm.CategoryListID = @categorylistid
	   AND h.Type = @nodetypeid

	SELECT @ErrorCode = @@ERROR
	
	IF @ErrorCode <> 0 GOTO HandleError

RETURN 0

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode