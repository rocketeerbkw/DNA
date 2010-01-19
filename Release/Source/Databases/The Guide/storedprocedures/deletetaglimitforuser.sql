CREATE PROCEDURE deletetaglimitforuser @inodetype int, @isiteid int
As
DECLARE @NodeTypeID int
SELECT @NodeTypeID = NodeTypeID FROM HierarchyNodeTypes WHERE NodeType = @inodetype AND SiteID = @isiteid

DELETE FROM UserTagLimits WHERE NodeTypeID = @NodeTypeID
RETURN @@ERROR