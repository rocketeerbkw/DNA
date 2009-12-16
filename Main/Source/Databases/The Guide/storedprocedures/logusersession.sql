CREATE PROCEDURE logusersession @userid INT, @logdate datetime = NULL, @siteid INT
AS

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

IF @logdate IS NULL
	SELECT @logdate  = getdate()
declare @cursession int, @lastlogged datetime

BEGIN TRANSACTION
SELECT TOP 1 @cursession = SessionID, @lastlogged = DateLastLogged FROM Sessions with(updlock)
	WHERE UserID = @userid AND SiteID = @siteid AND DateClosed IS NULL ORDER BY DateLastLogged DESC

IF (@cursession IS NOT NULL)
BEGIN
	IF (DATEDIFF(minute, @lastlogged, @logdate) > 15)
	BEGIN
		DECLARE @ErrorCode INT

		UPDATE Sessions SET DateClosed = DateLastLogged WHERE SessionID = @cursession --UserID = @userid --
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
		
		INSERT INTO Sessions (UserID, DateStarted, DateLastLogged, SiteID)
			VALUES (@userid, @logdate, @logdate, @siteID)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

	END
	ELSE
	BEGIN
		UPDATE Sessions SET DateLastLogged = @logdate, AccessCount = AccessCount + 1 WHERE SessionID = @cursession
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
END
ELSE
BEGIN
	INSERT INTO Sessions (UserID, DateStarted, DateLastLogged, siteID )
		VALUES (@userid, @logdate, @logdate, @siteID)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
END

COMMIT TRANSACTION


