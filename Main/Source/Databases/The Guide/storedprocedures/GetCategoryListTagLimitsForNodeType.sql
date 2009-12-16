CREATE PROCEDURE getcategorylisttaglimitsfornodetype @nodetypeid INT, @siteid INT, @taglimit INT OUTPUT
AS
	/* 
		Outputs the site specific tag limit for the node's hierarchy type (see table HierarchyNodeTypes). 
	*/

	DECLARE @ErrorCode	INT

	SELECT @taglimit = Limit
	  FROM dbo.CategoryListTagLimits
	 WHERE NodeTypeID = @nodetypeid
	   AND SiteID = @siteid

	SELECT @ErrorCode = @@ERROR
	
	IF @ErrorCode<>0 GOTO HandleError

RETURN 0

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode