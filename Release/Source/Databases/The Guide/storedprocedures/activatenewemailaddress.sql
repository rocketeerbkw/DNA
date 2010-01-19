Create Procedure activatenewemailaddress @userid int, @secretkey int
As
	declare @newemail varchar(255)
	SELECT @newemail = newemail FROM EmailChange WHERE UserID = @userid AND SecretKey = @secretkey AND DateCompleted IS NULL
	IF @newemail IS NULL
	BEGIN	
		declare @datecompleted datetime, @actualuser int
		SELECT TOP 1 @datecompleted = DateCompleted, @actualuser = UserID FROM EmailChange WHERE SecretKey = @secretkey
		IF @actualuser IS NULL
			SELECT 'Success' = 0, 'Message' = 'the key value wasn''t found'
		ELSE IF @actualuser <> @userid
			SELECT 'Success' = 0, 'Message' = 'you are not registered as the user whose address you are changing'
		ELSE IF @datecompleted IS NOT NULL
			SELECT 'Success' = 0, 'Message' = 'your address has already been changed'
		ELSE
			SELECT 'Success' = 0, 'Message' = 'of an unknown problem'
	END
	ELSE
	BEGIN
		BEGIN TRANSACTION 
		DECLARE @ErrorCode INT

		UPDATE Users SET email = @newemail WHERE UserID = @userid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Message' = 'Failed to update email address'
			RETURN @ErrorCode
		END

		UPDATE EmailChange SET DateCompleted = getdate() WHERE SecretKey = @secretkey AND UserID = @userid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Message' = 'Failed to update email address'
			RETURN @ErrorCode
		END
		ELSE
		BEGIN
			COMMIT TRANSACTION
		END

		SELECT 'Success' = 1, 'Message' = 'Successfully updated email address'
	END
	return (0)