CREATE PROCEDURE deletetaglimitforthread @inodetype int, @isiteid int
As
DECLARE @NodeTypeID int, @Error int
SELECT @NodeTypeID = NodeTypeID FROM HierarchyNodeTypes WHERE NodeType = @inodetype AND SiteID = @isiteid
BEGIN TRANSACTION
	DELETE FROM ThreadTagLimits WHERE NodeTypeID = @NodeTypeID
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @Error
	END
COMMIT TRANSACTION