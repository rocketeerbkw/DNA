CREATE PROCEDURE updatesitetopicsclosed @siteid INT, @siteemergencyclosed INT
AS
DECLARE @Error int
BEGIN TRANSACTION

	UPDATE dbo.Sites SET SiteEmergencyClosed = @siteemergencyclosed WHERE SiteID = @siteid
	SET @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END

COMMIT TRANSACTION