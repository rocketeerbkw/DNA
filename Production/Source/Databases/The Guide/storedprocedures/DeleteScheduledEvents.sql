CREATE PROCEDURE deletescheduledevents @siteid INT
AS
DECLARE @Error int
BEGIN TRANSACTION
	DELETE FROM dbo.SiteTopicsOpenCloseTimes WHERE SiteID = @siteID
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
COMMIT TRANSACTION