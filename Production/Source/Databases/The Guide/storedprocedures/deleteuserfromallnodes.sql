/* Delete user from all hierarhcy nodes */
CREATE PROCEDURE deleteuserfromallnodes @userid int,  @siteid int, @nodetypename varchar(50) = NULL
As

DECLARE @ErrorCode INT
DECLARE @Success INT

DECLARE @nodeids AS table ( nodeid INT )
IF @nodetypename IS NOT NULL
BEGIN
	INSERT INTO @nodeids
	SELECT hu.nodeid FROM HierarchyUserMembers hu
	INNER JOIN Hierarchy h ON h.NodeId = hu.NodeId
	INNER JOIN HierarchyNodeTypes n WITH(NOLOCK) ON n.NodeType = h.Type AND n.SiteID = @siteid AND n.Description LIKE @nodetypename
	WHERE hu.userid = @userid
END
ELSE
BEGIN
	INSERT INTO @nodeids SELECT nodeid FROM HierarchyUserMembers WHERE userid = @userid
END

BEGIN TRANSACTION

DELETE FROM [dbo].hierarchyusermembers	WHERE nodeid IN ( SELECT nodeid FROM @nodeids )
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

UPDATE [dbo].Hierarchy
	SET UserMembers = usermembers - 1 
	WHERE nodeid IN ( Select nodeid FROM @nodeids ) AND usermembers > 0
SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

COMMIT TRANSACTION


SELECT 'Success' = 1, 'ObjectName' = ( SELECT username FROM users WHERE userid = @userid ), 'NodeName' = h.displayname
FROM Hierarchy h
INNER JOIN @nodeids n ON n.nodeid = h.nodeid

RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode