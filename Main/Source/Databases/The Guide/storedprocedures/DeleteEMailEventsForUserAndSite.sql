CREATE PROCEDURE deleteemaileventsforuserandsite @userid int, @siteid int, @notifytype int
AS
DECLARE @Error int
BEGIN TRANSACTION
	DECLARE @ListID uniqueidentifier
	SELECT @ListID = EMailAlertListID FROM dbo.EmailAlertList WHERE UserID = @userid AND SiteID = @siteid
	DELETE FROM dbo.EMailEventQueue WHERE ListID = @ListID AND NotifyType = @notifytype
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
COMMIT TRANSACTION