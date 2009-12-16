CREATE PROCEDURE movehierarchynode @nodeid INT, @newparentid INT
AS
/*
	This moves a hierarchy node to another place within the hierarchy, defined 
	by the new parent id.
	
	The two tables that need to be maintained are the hierarchy table and the
	ancestors table
	
	When moving a node within the hierarchy table, we need to change the parent node
	to be the new parent, then update the treelevel for the node and all it's decendants.
	The amount the treelevel changes is calculated based on where the node was, and where
	it will be after the move.
	
	The Ancestors table is a little trickier.
	
	For the node and it's decendants, we only want to delete ancestor entries that reference nodes
	that were above the moving node.  I.e. the node is moving, so it's ancestors will be different, and so
	the node's decendants ancestors that were above the node will be different.  These ancestor entries
	need to be deleted. (It's much easier to explain with a diagram!)
	
	For the remaining ancestor entries for the moving node, all that needs maintaining is the treelevel.
	The amount the treelevel changes is the same as the amount the treelevels where changed in the hierarchy
	
	Next we need to add an ancestor entry that states the new parent is an ancestor of the new node,
	and then for every ancestor entry the new parent has, insert a new entry that states that it is 
	also an ancestor of the moving node now.
	
	We now have ancestor information for the moving node in its new position.  Everyone one of these
	entries applies to the moving node's descendants too, so for each descendant, insert an entry 
	defining the node's ancestors to be ancestors of the decendants too.
	
	Finally, we need to make sure the hierarchy counts are correct.  The only nodes that need the counts
	updated are the new parent and the original parent
		
*/

-- new parent can't be the node itself
IF @nodeid = @newparentid
BEGIN
	SELECT 'result'='nodes are the same'
	RETURN 0
END

-- new parent can't be one of the node's decendants
IF EXISTS (SELECT * FROM ancestors WHERE nodeid=@newparentid AND ancestorid=@nodeid)
BEGIN
	SELECT 'result'='new parent is a decentant of the node that is moving'
	RETURN 0
END

-- if either id is NULL, fail
IF @nodeid IS NULL OR @newparentid IS NULL
BEGIN
	SELECT 'result'='NULL parameters found'
	RETURN 0
END

BEGIN TRANSACTION
DECLARE @ErrorCode INT

DECLARE @newparentTL INT, @origparentid INT, @origTL INT, @diffTL INT

-- note the original treelevel of the node that is moving
SELECT @origTL = treelevel, @origparentid=parentid FROM hierarchy WHERE nodeid=@nodeid
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

-- if the original parent is the same as the new one, do nothing
IF @origparentid IS NOT NULL AND @origparentid=@newparentid GOTO ReturnWithoutError

-- update the node's parent id
UPDATE hierarchy SET parentid = @newparentid
	WHERE nodeid = @nodeid
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

-- note the new parent's treelevel
SELECT @newparentTL = treelevel FROM hierarchy WHERE nodeid=@newparentid
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

-- calculate the value that needs to be added to the treelevels so they are correct
-- for the nodes in their new position in the hierarchy 
set @diffTL = (@newparentTL-@origTL)+1

IF @diffTL<>0
BEGIN
	-- update the node's tree level
	UPDATE hierarchy set treelevel = treelevel+@diffTL
		WHERE nodeid = @nodeid
	SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError
	
	-- update the decendents tree level
	UPDATE hierarchy SET hierarchy.treelevel = hierarchy.treelevel+@diffTL
		FROM ancestors a WHERE a.ancestorid=@nodeid
		AND hierarchy.nodeid=a.nodeid
	SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError
END

-- delete the ancestor entries for the moving node's decendants, where they reference nodes above the moving node
-- as these could be completely different
DELETE FROM ancestors WHERE treelevel < @origTL AND nodeid IN (SELECT nodeid FROM ancestors WHERE ancestorid=@nodeid)
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

-- delete the ancestor entries for the moving node, where they reference nodes above the moving node
-- as these could be completely different
DELETE FROM ancestors WHERE treelevel < @origTL AND nodeid=@nodeid
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

IF @diffTL <> 0
BEGIN
	-- update the levels in the valid rows of the ancestor's table
	UPDATE ancestors SET treelevel = treelevel+@diffTL
		FROM ancestors WHERE treelevel >=@origTL AND nodeid IN (SELECT nodeid FROM ancestors WHERE ancestorid=@nodeid)
	SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError
END

-- insert immediate ancestor for node
INSERT INTO ancestors (NodeID, AncestorID, TreeLevel)
	SELECT NodeID, ParentID, TreeLevel-1 FROM Hierarchy 
		WHERE nodeid=@nodeid
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

-- insert other ancestors for node
INSERT INTO ancestors (NodeID, AncestorID, TreeLevel)
	SELECT @nodeid, a1.AncestorID, a1.TreeLevel FROM ancestors a1 
		WHERE a1.NodeID = @newparentid
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

-- insert ancestors for node's children
INSERT INTO ancestors (NodeID, AncestorID, TreeLevel)
	SELECT a2.nodeid, a1.AncestorID, a1.TreeLevel FROM ancestors a1
		INNER JOIN ancestors a2 ON a2.ancestorid = @nodeid
		WHERE a1.nodeid = @nodeid
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

-- update hierarchy counts for the new and original parent nodes
EXEC @ErrorCode = updatehierarchycounts @newparentid
SET @ErrorCode = dbo.udf_checkerr(@@ERROR,@ErrorCode); IF (@ErrorCode <> 0) GOTO HandleError

EXEC @ErrorCode = updatehierarchycounts @origparentid
SET @ErrorCode = dbo.udf_checkerr(@@ERROR,@ErrorCode); IF (@ErrorCode <> 0) GOTO HandleError

-- Delete the alias node link, if it exists
EXEC @ErrorCode = deletealiasfromhierarchy @nodeid, @newparentid
SET @ErrorCode = dbo.udf_checkerr(@@ERROR,@ErrorCode); IF (@ErrorCode <> 0) GOTO HandleError

ReturnWithoutError:
COMMIT TRANSACTION
SELECT 'result'='ok'
RETURN 0

HandleError:
ROLLBACK TRANSACTION
EXEC Error @ErrorCode
RETURN @ErrorCode
