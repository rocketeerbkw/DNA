Create Procedure supercede @entryid int
As
/*
This article will now supercede the article on which it is based.
In the BasedOn article set the DateExpired field, the Superceded by
field and the LatestVersion field, also update the LatestVerwion
field of any other entry whose LatestVersion is the entry being superceded
*/

declare @oldentry int
SELECT @oldentry = BasedOn FROM GuideEntries WHERE EntryID = @entryid

BEGIN TRANSACTION
DECLARE @ErrorCode INT

UPDATE GuideEntries
	SET DateExpired = getdate(), SupercededBy = @entryid, LatestVersion = @entryid
	WHERE EntryID = @oldentry
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

/* Update all other superceded entries */
UPDATE GuideEntries
	Set LatestVersion = @entryid WHERE LatestVersion = @oldentry
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)