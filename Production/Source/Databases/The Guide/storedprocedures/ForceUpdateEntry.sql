CREATE PROCEDURE forceupdateentry @h2g2id INT = 0, @clubid INT = 0
AS

BEGIN TRANSACTION
DECLARE @ErrorCode INT

IF ( @h2g2id <> 0 ) 
BEGIN
	UPDATE [dbo].GuideEntries SET LastUpdated = GETDATE() WHERE h2g2ID = @h2g2id
	SELECT @ErrorCode = @@ERROR
END

IF ( @clubid <> 0 ) 
BEGIN
	UPDATE [dbo].Clubs SET LastUpdated = GETDATE() WHERE clubID = @clubid
	SELECT @ErrorCode = @@ERROR
END

IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END



COMMIT TRANSACTION