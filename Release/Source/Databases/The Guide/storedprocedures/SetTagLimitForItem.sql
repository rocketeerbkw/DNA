CREATE PROCEDURE settaglimitforitem @iitemtype int, @inodetype int, @ilimit int = NULL, @isiteid int
As
-- Check to make sure the Node type exist!
IF NOT EXISTS ( SELECT NodeType FROM HierarchyNodeTypes WHERE NodeType = @inodetype AND SiteID = @isiteid )
BEGIN
	EXEC Error 50000
	RETURN 50000
END

-- Check to see if we're updating a previous value or creating a new entry!
DECLARE @Error int, @inodetypeID int
SELECT @inodetypeID = NodeTypeID FROM HierarchyNodeTypes WHERE SiteID = @isiteid AND NodeType = @inodetype
IF EXISTS
(
	SELECT * FROM HierarchyNodeTypes h
	INNER JOIN ArticleTagLimits a ON a.NodeTypeID = h.NodeTypeID
	WHERE a.ArticleType = @iitemtype AND h.NodeType = @inodetype AND h.SiteID = @isiteid
)
BEGIN
	-- Update the existing value
	BEGIN TRANSACTION
		UPDATE ArticleTagLimits SET Limit = @ilimit WHERE NodeTypeID = @inodetypeID AND ArticleType = @iitemtype
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	COMMIT TRANSACTION
END
ELSE
BEGIN
	-- Insert a new value into the table
	BEGIN TRANSACTION
		INSERT INTO ArticleTagLimits (NodeTypeID,ArticleType,Limit) VALUES (@inodetypeID,@iitemtype,@ilimit)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	COMMIT TRANSACTION
END
