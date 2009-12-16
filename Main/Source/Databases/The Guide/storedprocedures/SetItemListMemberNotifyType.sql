CREATE PROCEDURE setitemlistmembernotifytype @itemlistid uniqueidentifier, @memberid int, @notifytype int
AS
DECLARE @Error int
IF EXISTS ( SELECT * FROM ItemListMembers WHERE MemberID = @memberid AND ItemListID = @itemlistid )
BEGIN
	BEGIN TRANSACTION
		-- Set the new notify type for the memebr
		UPDATE ItemListMembers SET NotifyType = @notifytype WHERE ItemListID = @itemlistid AND MemberID = @memberid
		SELECT @Error = @@ERROR
		IF (@Error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @Error
			RETURN @Error
		END

		-- Set the last updated value for the list		
		UPDATE ItemList SET LastUpdated = GetDate() WHERE ItemListID = @itemlistid
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