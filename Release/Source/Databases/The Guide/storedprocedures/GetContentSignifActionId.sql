CREATE PROCEDURE getcontentsignifactionid 
	@actiondesc 	VARCHAR(255), 
	@actionid 		INT OUTPUT
AS
	/*
		Returns the ActionID for action description.
	*/
	DECLARE @ErrorCode	INT

	SELECT @actionid = ActionID
	  FROM dbo.ContentSignifAction
	 WHERE ActionDesc = @actiondesc

	SELECT @ErrorCode = @@ERROR
	
	IF @ErrorCode<>0 GOTO HandleError

RETURN 0

-- Error handling
HandleError:
	EXEC dbo.Error @errorcode = @ErrorCode
	RETURN @ErrorCode