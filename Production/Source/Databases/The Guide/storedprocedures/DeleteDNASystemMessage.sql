CREATE PROCEDURE deletednasystemmessage @msgid INT
AS
BEGIN
	BEGIN TRANSACTION;
	
	BEGIN TRY	
		DELETE FROM dbo.DNASystemMessages
		OUTPUT deleted.MsgId, deleted.UserID, deleted.SiteID, deleted.MessageBody, deleted.DatePosted
		 WHERE MsgID = @msgid;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
    	ROLLBACK TRANSACTION
	
		EXEC dbo.geterrorinfo

		RETURN 1
	END CATCH;
	
	RETURN 0;

END