CREATE PROCEDURE deletetaglimitforitem @iitemtype int, @inodetype int, @isiteid int
As
DECLARE @NodeTypeID int, @Error int
SELECT @NodeTypeID = NodeTypeID FROM HierarchyNodeTypes WHERE NodeType = @inodetype AND SiteID = @isiteid
BEGIN TRANSACTION
	DELETE FROM ArticleTagLimits WHERE NodeTypeID = @NodeTypeID AND ArticleType = @iitemtype
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
COMMIT TRANSACTION
