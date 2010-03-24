CREATE PROCEDURE deletealiasfromhierarchy @linknodeid int, @nodeid int
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

IF EXISTS (SELECT * FROM hierarchynodealias WHERE linknodeid = @linknodeid and nodeid = @nodeid)
BEGIN
	DELETE FROM hierarchynodealias WHERE linknodeid = @linknodeid and nodeid = @nodeid
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	UPDATE Hierarchy SET NodeAliasMembers = NodeAliasMembers-1 WHERE nodeid = @nodeid AND NodeAliasMembers > 0
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
END
	
COMMIT TRANSACTION

RETURN(0)

HandleError:
ROLLBACK TRANSACTION
EXEC Error @ErrorCode
RETURN @ErrorCode
