CREATE PROCEDURE uploadimage	@siteid int, @userid int, 
	@description VARCHAR(255), @mime VARCHAR(50)
AS


BEGIN TRANSACTION
DECLARE @ErrorCode INT

INSERT INTO ImageLibrary (UserId, Description, Mime) VALUES (@userid, @description, @mime);
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

DECLARE @ImageId INT;
SELECT @ImageId = @@IDENTITY;

INSERT INTO ImageMod (ImageID, DateQueued, Status, Notes, SiteID)
VALUES (@ImageID, GETDATE(), 0, '', @siteid)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

SELECT 1 AS 'Success', @ImageId AS 'ImageID'
