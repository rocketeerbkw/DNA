CREATE PROCEDURE updatemessageboardadminstatus @type int, @status int, @siteid int
AS
DECLARE @tasktypeexists int
DECLARE @ErrorCode int

Select @tasktypeexists = Type FROM MessageBoardAdminStatus
WHERE SiteID = @siteid AND Type = @type

BEGIN TRANSACTION

IF(@tasktypeexists IS NULL)
BEGIN
	-- create the row for the missing type
	INSERT INTO MessageBoardAdminStatus (SiteID, Type, Status, LastUpdated)
	VALUES (@SiteID, @type, @status, GETDATE())
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	COMMIT TRANSACTION
	return (0)
END

-- update the status and date for the given row
UPDATE MessageBoardAdminStatus SET LastUpdated = GETDATE(), Status = @status
WHERE SiteId = @siteid AND Type = @type

SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)