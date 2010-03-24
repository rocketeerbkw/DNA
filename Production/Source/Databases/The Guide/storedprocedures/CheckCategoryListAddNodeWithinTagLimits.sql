CREATE PROCEDURE checkcategorylistaddnodewithintaglimits @categorylistid uniqueidentifier, @nodeid INT, @allowed INT OUTPUT
AS
	/*
		Checks if an attempt to add a hierarchy node to a category list is within the tag limits. 
	*/

	DECLARE @ErrorCode	INT
	DECLARE @TagLimit	INT
	DECLARE @NodeTypeID	INT
	DECLARE @SiteID		INT
	DECLARE @NumberOfNodesCategoryListIsTaggedTo	INT

	EXEC @ErrorCode = dbo.getnodestypeid @nodeid 		= @nodeid, 
										 @nodetypeid	= @NodeTypeID OUTPUT

	IF @ErrorCode<>0 GOTO HandleError

	EXEC @ErrorCode = dbo.getnumberofnodescategorylististaggedto @categorylistid 	= @categorylistid, 
																 @nodetypeid		= @NodeTypeID, 
																 @numberofnodescategorylististaggedto = @NumberOfNodesCategoryListIsTaggedTo OUTPUT

	IF @ErrorCode<>0 GOTO HandleError

	SELECT @SiteID = SiteID
	  FROM Hierarchy
	 WHERE NodeID = @nodeid

	SELECT @ErrorCode = @@ERROR 

	IF @ErrorCode<>0 GOTO HandleError

	EXEC @ErrorCode = dbo.getcategorylisttaglimitsfornodetype @nodetypeid 	= @NodeTypeID, 
															  @siteid 		= @SiteID, 
															  @taglimit 	= @TagLimit OUTPUT	

	IF @ErrorCode<>0 GOTO HandleError

	IF (@numberofnodescategorylististaggedto >= @TagLimit)
	BEGIN
		-- Can't tag CategoryList to another category of that type. 
		SELECT @allowed = 0
	END
	ELSE
	BEGIN
		SELECT @allowed = 1
	END

RETURN 0

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode