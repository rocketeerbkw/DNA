CREATE PROCEDURE getmessageboardadminstatusindicators @siteid int
AS
DECLARE @ErrorCode int

SELECT * FROM MessageBoardAdminStatus WHERE SiteID = @siteid
Order by Type

SELECT @ErrorCode = @@ERROR
IF(@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END
