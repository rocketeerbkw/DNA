Create Procedure rebuildancestors
As
/*
	This rebuilds the ancestors table by creating the table in Ancestors2, then renaming
	the tables so Ancestors and Ancestors2 are swapped.
	
	It works by building the ancestors a treelevel at a time.
	
	For each treelevel, there is one ancestor row per hierarchy node at that treelevel that
	specifies it's parent as an ancestor.
	
	Also for each level, each node at that level needs an ancestor row for every ancestor it's parent has
*/

DECLARE @treelevel INT, @maxtreelevel INT, @ErrorCode INT

BEGIN TRANSACTION

-- clear out the work table
--TRUNCATE TABLE Ancestors2
DELETE FROM Ancestors2
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

-- find out how many tree levels we need to go through
SELECT TOP 1 @maxtreelevel = treelevel FROM hierarchy ORDER BY treelevel DESC
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

SET @treelevel = 1
WHILE (@treelevel <= @maxtreelevel)
BEGIN
	-- add an ancestor row for each node at the current level, that states it's parent is an ancestor
	INSERT INTO Ancestors2 (NodeID, AncestorID, TreeLevel)
		SELECT NodeID, ParentID, TreeLevel-1 FROM Hierarchy WHERE TreeLevel = @treelevel
	SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

	-- For every ancestor row associated with the parent, add a row that states that the node itself
	-- is an ancestor.  Do this for every node at the current tree level
	INSERT INTO Ancestors2 (NodeID, AncestorID, TreeLevel)
		SELECT h.NodeID, a1.AncestorID, a1.TreeLevel FROM Ancestors2 a1 
			INNER JOIN hierarchy h ON a1.NodeID = h.parentID AND h.TreeLevel = @treelevel
	SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

	SET @treelevel = @treelevel+1
end

-- Rename the tables, so that Ancestor2 and Ancestor swap around.
EXECUTE sp_rename N'dbo.Ancestors', N'Ancestorstmp', 'OBJECT'
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

EXECUTE sp_rename N'dbo.Ancestors2', N'Ancestors', 'OBJECT'
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

EXECUTE sp_rename N'dbo.Ancestorstmp', N'Ancestors2', 'OBJECT'
SELECT @ErrorCode=@@ERROR; IF @ErrorCode<>0 GOTO HandleError

COMMIT TRANSACTION
RETURN (0)

HandleError:
ROLLBACK TRANSACTION
EXEC Error @ErrorCode
RETURN @ErrorCode


