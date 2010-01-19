CREATE PROCEDURE unarchivetopic @topicid int, @editorid int, @validtopic int OUTPUT
AS
SET @validtopic = 0
BEGIN TRANSACTION

DECLARE @ErrorCode int
EXEC @ErrorCode = unarchivetopicinternal @topicid, @editorid, @validtopic OUTPUT
SET @ErrorCode = dbo.udf_checkerr(@@ERROR,@ErrorCode)
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION