CREATE PROCEDURE getnodestypeid @nodeid INT, @nodetypeid INT OUTPUT
AS
	/*
		Outputs the nodetypeid for a node. 
	*/

	DECLARE @ErrorCode	INT

	SELECT @nodetypeid = nodetypeid
	  FROM Hierarchy h
		   INNER JOIN HierarchyNodeTypes hnt ON hnt.NodeType = h.Type AND hnt.SiteID = h.SiteID
	 WHERE h.NodeID = @nodeid

	SELECT @ErrorCode = @@ERROR
	
	IF @ErrorCode <> 0 GOTO HandleError

RETURN 0

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode