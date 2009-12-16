CREATE PROCEDURE updateuploadstatus  @uploadid int, @newstatus int
AS
DECLARE @ErrorCode INT
BEGIN TRANSACTION

	UPDATE Uploads SET Status = @newstatus WHERE UploadID = @uploadid

	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

COMMIT TRANSACTION
Select 'Success' = 1
