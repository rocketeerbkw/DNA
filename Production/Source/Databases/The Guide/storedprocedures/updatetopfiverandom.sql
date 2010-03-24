Create Procedure updatetopfiverandom
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

declare @maxarticle int
SELECT @maxarticle = MAX(EntryID) FROM GuideEntries WHERE Status = 1
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @startarticle int
SELECT @startarticle = CONVERT(int, (RAND() * @maxarticle)+1)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

DELETE FROM TopFives WHERE GroupName = 'Random'
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO TopFives (GroupName, h2g2ID)
	SELECT TOP 5 'Random' = 'Random', 'h2g2ID' = h2g2id FROM GuideEntries g  WHERE g.EntryID >= @startarticle AND Status = 1 ORDER BY g.EntryID 
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
return (0)