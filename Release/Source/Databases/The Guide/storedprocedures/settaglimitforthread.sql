CREATE PROCEDURE settaglimitforthread @inodetype int, @ilimit int = NULL, @isiteid int
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
	SELECT h.NodeTypeID FROM HierarchyNodeTypes h
	INNER JOIN ThreadTagLimits a ON a.NodeTypeID = h.NodeTypeID
	WHERE h.NodeType = @inodetype AND h.SiteID = @isiteid
)
BEGIN
	-- Update the existing value
	BEGIN TRANSACTION
		UPDATE ThreadTagLimits SET Limit = @ilimit WHERE NodeTypeID = @inodetypeID
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
		INSERT INTO ThreadTagLimits (NodeTypeID,Limit) VALUES (@inodetypeID,@ilimit)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	COMMIT TRANSACTION
END
