CREATE PROCEDURE deletetopfive @groupname varchar(255) , @siteid INT
AS
    DECLARE @ErrorCode INT
    
	DELETE FROM TopFives WHERE SiteID = @siteid AND GroupName = @groupname
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	RETURN 0