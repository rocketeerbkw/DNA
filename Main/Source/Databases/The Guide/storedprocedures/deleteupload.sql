CREATE PROCEDURE deleteupload  @uploadid int
AS
DECLARE @ErrorCode INT
BEGIN TRANSACTION

	DELETE FROM Uploads WHERE UploadID = @uploadid

	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

COMMIT TRANSACTION
Select 'Success' = 1
