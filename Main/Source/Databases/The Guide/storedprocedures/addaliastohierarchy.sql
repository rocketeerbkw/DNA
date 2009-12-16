CREATE PROCEDURE addaliastohierarchy @nodeid int, @linknodeid int
As

BEGIN TRANSACTION 
DECLARE @ErrorCode INT

INSERT INTO hierarchynodealias (NodeID,LinkNodeID)
	VALUES(@nodeid,@linknodeid)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @aliascnt int
SELECT @aliascnt = NodeAliasMembers FROM hierarchy where nodeid=@nodeid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END


IF (@aliascnt IS NOT NULL)
BEGIN
	UPDATE hierarchy
		SET NodeAliasMembers = 1 + (SELECT NodeAliasMembers From hierarchy where nodeid=@nodeid) WHERE nodeid=@nodeid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
ELSE
BEGIN
	UPDATE hierarchy
		SET NodeAliasMembers = 1 WHERE nodeid=@nodeid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

COMMIT TRANSACTION

return(0)