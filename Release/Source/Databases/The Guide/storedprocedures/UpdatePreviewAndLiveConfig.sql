CREATE PROCEDURE updatepreviewandliveconfig @siteid int, @config text, @editkey uniqueidentifier
AS
BEGIN TRANSACTION

DECLARE @ErrorCode INT

-- First check to make sure the edit key is correct
DECLARE @CurrentEditKey uniqueidentifier
SELECT @CurrentEditKey = EditKey FROM dbo.PreviewConfig WHERE SiteID = @siteid
IF (@CurrentEditKey <> @editkey)
BEGIN
	SELECT 'ValidKey' = 0
	RETURN 0
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

UPDATE dbo.Sites
	SET Config = @config
	WHERE SiteID = @siteid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END

COMMIT TRANSACTION
SELECT 'ValidKey' = 1