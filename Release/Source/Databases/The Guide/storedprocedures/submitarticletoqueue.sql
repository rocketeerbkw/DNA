CREATE PROCEDURE submitarticletoqueue @h2g2id int, @editorid int = 13
 AS
declare @entryid int
SELECT @entryid = @h2g2id / 10

BEGIN TRANSACTION
DECLARE @ErrorCode INT

UPDATE GuideEntries SET Status = 4 WHERE h2g2ID = @h2g2id
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

EXEC @ErrorCode = createedithistory @entryid, @editorid, 5, NULL, 'Submitted to queue'
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION


