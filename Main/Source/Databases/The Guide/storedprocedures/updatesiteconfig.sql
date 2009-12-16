CREATE PROCEDURE updatesiteconfig @siteid int, @config text
As
BEGIN TRANSACTION

DECLARE @ErrorCode INT

UPDATE sites 
	SET Config = @config
	WHERE SiteID = @siteid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END

UPDATE dbo.PreviewConfig
	SET Config = @config, EditKey = NewID()
	WHERE SiteID = @siteid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END

COMMIT TRANSACTION
