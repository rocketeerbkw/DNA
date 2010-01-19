CREATE PROCEDURE disableuseremailalerts @userid int, @guid uniqueidentifier
AS
-- Check to see if we have any lists that match the userid and the guid.
DECLARE @FoundMatch int
SET @FoundMatch = 0
IF EXISTS (SELECT * FROM dbo.EMailAlertList WHERE UserId = @userid AND EMailAlertListID = @guid) OR
		EXISTS (SELECT * FROM dbo.InstantEMailAlertList WHERE UserId = @userid AND InstantEMailAlertListID = @guid)
BEGIN
	-- Found a match, disable all the alerts
	DECLARE @Error int
	BEGIN TRANSACTION
		-- Start with the Normal Email Alerts
		UPDATE dbo.EMailAlertListMembers SET NotifyType = 3 WHERE EmailAlertListID IN
			(SELECT EmailAlertListID FROM dbo.EMailAlertList WHERE UserID = @userid)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
		
		-- Now do the instant alerts
		UPDATE dbo.EMailAlertListMembers SET NotifyType = 3 WHERE EmailAlertListID IN
			(SELECT InstantEmailAlertListID FROM dbo.InstantEMailAlertList WHERE UserID = @userid)
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	COMMIT TRANSACTION

	-- Everything went ok, return ok!	
	SET @FoundMatch = 1
END
SELECT 'FoundMatch' = @FoundMatch