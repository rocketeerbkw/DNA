CREATE PROCEDURE setredirectfornodeandchildren @nodetohide INT, @redirectnodeid INT
AS
-- Check to make sure that the redirect nodeid exists. Don't bother with the node as nothing will be updated if it doesn't exist
IF NOT EXISTS ( SELECT * FROM dbo.Hierarchy WHERE NodeID = @RedirectNodeID )
BEGIN
	-- Redirect node does not exist
	RAISERROR('The redirect node does not exist!',16,1)
	RETURN @@ERROR;
END
BEGIN TRANSACTION
DECLARE @Error int
-- Update the nodes effected by the hidding of this node
UPDATE dbo.Hierarchy SET Hierarchy.RedirectNodeID = @RedirectNodeID WHERE Hierarchy.NodeID IN
(
	-- Select the node and all the children that do not already have a redirect set for them.
	SELECT DISTINCT a.NodeID FROM dbo.Ancestors a
		INNER JOIN dbo.Hierarchy h ON h.NodeID = a.NodeID
	WHERE (a.AncestorID = @NodeToHide OR a.NodeID = @NodeToHide) AND h.RedirectNodeID IS NULL
)
SELECT @Error = @@ERROR
IF (@Error > 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN @Error
END
COMMIT TRANSACTION