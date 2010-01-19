
CREATE Procedure addcategory @parentid int, @name varchar(255)
As
declare @newnode int, @parenttreelevel int

BEGIN TRANSACTION
DECLARE @ErrorCode INT

SELECT @parenttreelevel = TreeLevel FROM Hierarchy WITH(UPDLOCK) WHERE NodeID = @parentid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO Hierarchy (ParentID, DisplayName, TreeLevel, LastUpdated)
	VALUES(@parentid, @name, @parenttreelevel+1, getDate())
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

select @newnode = @@IDENTITY

INSERT INTO Ancestors (NodeID, AncestorID, TreeLevel) SELECT @newnode, AncestorID, TreeLevel FROM Ancestors WHERE NodeID = @parentid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO Ancestors (NodeID, AncestorID, TreeLevel) VALUES (@newnode, @parentid, @parenttreelevel)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

SELECT 'NodeID' = @newnode
return (0)
