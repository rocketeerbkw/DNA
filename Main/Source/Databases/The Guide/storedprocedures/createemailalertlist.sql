CREATE PROCEDURE createemailalertlist @userid int, @siteid int
AS
DECLARE @Error int, @GUID uniqueidentifier
SELECT @GUID = NewID()
BEGIN TRANSACTION
INSERT INTO dbo.EMailAlertList (EmailAlertListID,UserID,CreatedDate,LastUpdated,SiteID)
	VALUES (@GUID,@userid,GetDate(),GetDate(),@siteid)
SELECT @Error = @@ERROR
IF (@Error <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @Error
	RETURN @Error
END
COMMIT TRANSACTION
SELECT 'EMailListID' = @GUID