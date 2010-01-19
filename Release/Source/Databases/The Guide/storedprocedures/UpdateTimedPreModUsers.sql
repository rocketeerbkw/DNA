CREATE PROCEDURE updatetimedpremodusers
AS

BEGIN TRANSACTION
DECLARE @Error INT

UPDATE dbo.Preferences
	SET PrefStatus = 0,
		PrefStatusDuration = NULL,
		PrefStatusChangedDate = NULL
	WHERE DATEADD(Minute,-PrefStatusDuration,GetDate()) > PrefStatusChangedDate
		AND PrefStatus IN (1,2)
		AND PrefStatusDuration IS NOT NULL
		AND PrefStatusDuration > 0
		
SET @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END
		
COMMIT TRANSACTION