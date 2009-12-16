CREATE PROCEDURE setnotifytypeforinstantemaillistmember @instantemailalertlistid uniqueidentifier, @memberid int, @notifytype int
AS
DECLARE @Error int
IF EXISTS ( SELECT * FROM dbo.EMailAlertListMembers WHERE MemberID = @memberid AND EmailAlertListID = @instantemailalertlistid )
BEGIN
	BEGIN TRANSACTION
		-- Set the new notify type for the memebr
		UPDATE dbo.EMailAlertListMembers SET NotifyType = @notifytype WHERE EMailAlertListID = @instantemailalertlistid AND MemberID = @memberid
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END

		-- Set the last updated value for the list		
		UPDATE dbo.InstantEMailAlertList SET LastUpdated = GetDate() WHERE InstantEMailAlertListID = @instantemailalertlistid
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END
	COMMIT TRANSACTION
	SELECT 'Result' = 1
	RETURN 0
END
SELECT 'Result' = 0