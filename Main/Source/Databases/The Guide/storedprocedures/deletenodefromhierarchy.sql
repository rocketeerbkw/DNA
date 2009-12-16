CREATE PROCEDURE deletenodefromhierarchy @nodeid int
As

-- If the node has descendants, leave now
IF EXISTS (SELECT * FROM Ancestors WHERE AncestorID = @nodeid)
BEGIN
	SELECT 'Result'='HasDescendants'
	RETURN 0
END

BEGIN TRANSACTION
DECLARE @ErrorCode INT

-- Find the parent node, whilst putting an update lock on the node in question
DECLARE @parentid int
SELECT @parentid = ParentID FROM hierarchy WITH(UPDLOCK) where nodeid = @nodeid

-- Delete all the nodes that are decendants of this node
DELETE FROM Hierarchy WHERE NodeID IN (SELECT NodeID FROM Ancestors WITH(UPDLOCK) WHERE AncestorID = @nodeid)
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

-- Delete the node itself
DELETE FROM Hierarchy WHERE NodeID = @nodeid 
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

-- Update the node member count od the parent
UPDATE hierarchy SET NodeMembers = NodeMembers - 1 Where Nodeid = @parentid And NodeMembers > 0
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

-- Reduce the node alias count for all nodes that have an alias to the node we are deleting
-- Use UPDLOCK to ensure the same set is selected in following DELETE statement
UPDATE hierarchy SET NodeAliasMembers = NodeAliasMembers - 1 
	WHERE NodeID IN (SELECT NodeID FROM HierarchyNodeAlias (UPDLOCK) WHERE LinkNodeID = @nodeid) 
		AND NodeAliasMembers > 0
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

-- Delete all the aliases where this node is the link node
DELETE FROM HierarchyNodeAlias WHERE LinkNodeID = @nodeid
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

-- Delete all the ancestor entries that define this node's descendants
DELETE FROM Ancestors WHERE AncestorID = @nodeid
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

-- Delete all the ancestor entries that define this node's ancestors
DELETE FROM Ancestors WHERE NodeID = @nodeid
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

-- This node can no longer have any article members
DELETE FROM HierarchyArticleMembers WHERE NodeID = @nodeid
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

-- This node can no longer have any club members
DELETE FROM HierarchyClubMembers WHERE NodeID = @nodeid
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

-- This node can no longer have any user members
DELETE FROM HierarchyUserMembers WHERE NodeID = @nodeid
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

-- This node can no longer have any Thread members
DELETE FROM HierarchyThreadMembers WHERE NodeID = @nodeid
SELECT @ErrorCode = @@ERROR; IF @ErrorCode <> 0 GOTO HandleError

ReturnWithoutError:
COMMIT TRANSACTION
SELECT 'Result'='OK'
RETURN(0)

HandleError:
ROLLBACK TRANSACTION
EXEC Error @ErrorCode
RETURN @ErrorCode
