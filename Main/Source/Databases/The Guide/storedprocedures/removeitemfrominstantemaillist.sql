CREATE PROCEDURE removeitemfrominstantemaillist @memberid int, @emailalertlistid uniqueidentifier
AS
DECLARE @Error int, @Deleted int, @ItemID int, @ItemType int
SELECT @Deleted = 0
SELECT @ItemID = ItemID, @ItemType = ItemType FROM dbo.EMailAlertListMembers WHERE MemberID = @memberid AND EMailAlertListID = @emailalertlistid
IF ( @ItemID IS NOT NULL AND @ItemID > 0 )
BEGIN
	BEGIN TRANSACTION
	DELETE FROM dbo.EMailAlertListMembers WHERE MemberID = @memberid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	UPDATE dbo.InstantEMailAlertList SET LastUpdated = GetDate() WHERE InstantEMailAlertListID = @emailalertlistid
	SELECT @Error = @@ERROR
	IF (@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @Error
		RETURN @Error
	END
	COMMIT TRANSACTION
	
	SET @Deleted = 1
END
SELECT 'Deleted' = @Deleted, 'ItemID' = @ItemID, 'ItemType' = @ItemType
