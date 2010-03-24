CREATE PROCEDURE updateeverymessageboardadminstatusforsite @status int, @siteid int
AS
DECLARE @ErrorCode int

BEGIN TRANSACTION
-- update the status and date for the given row
UPDATE MessageBoardAdminStatus SET LastUpdated = GETDATE(), Status = @status
WHERE SiteId = @siteid

SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)