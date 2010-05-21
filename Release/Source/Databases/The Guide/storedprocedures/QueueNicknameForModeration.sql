/*
	Currently nickname moderation is simple (only has pass and fail options)
	so this SP does not have to do anything except insert the nickname if it
	is not already in the queue.
*/

CREATE PROCEDURE queuenicknameformoderation @userid int, @siteid int, @nickname NVARCHAR(255)
AS
DECLARE @ModID int, @Error int

if @nickname IS NOT NULL
BEGIN
	SELECT @nickname = REPLACE(@nickname, '<', '&lt;')
	SELECT @nickname = REPLACE(@nickname, '>', '&gt;')
END

-- first find out if this nickname is already queued and not dealt with.
SELECT TOP 1 @ModID = ModID
FROM NicknameMod
WHERE UserID = @userid AND Status = 0 AND lockedBy IS NULL
ORDER BY DateQueued ASC, ModID ASC

-- only queue the nickname if it is not already in the queued and the user ID
-- exists in the Users table
-- Make sure the date in both tables is identical
DECLARE @date datetime
SET @date=getdate()
IF ( @ModID IS NULL )
BEGIN
	INSERT INTO NicknameMod (UserID, NickName, Status, DateQueued, SiteID)
		VALUES (@userid, @nickname, 0, @date, @siteid)
	SET @Error = @@ERROR; IF @Error <> 0 GOTO HandleError
	
	SELECT @ModID = @@identity
	
	EXEC @Error = addnicknamemodhistory @ModID,0,0,NULL,3,NULL,@date
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF @Error <> 0 GOTO HandleError
	
END
ELSE
BEGIN
	-- Nickname already pending moderation - update with latest change.
	UPDATE NicknameMod SET NickName = @nickname, SiteID = @siteid
	WHERE ModID = @ModID
	SET @Error = @@ERROR; IF @Error <> 0 GOTO HandleError
	
	--Record the event in nickname mod history.
	EXEC @Error = addnicknamemodhistory @ModID,0,0,NULL,3,NULL,@date
	SET @Error = dbo.udf_checkerr(@@ERROR,@Error); IF @Error <> 0 GOTO HandleError
END

-- return the ModID
SELECT 'ModID' = @ModID
return (0)

HandleError:
RETURN @Error
