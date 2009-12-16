CREATE PROCEDURE moveforumtosite @forumid INT, @newsiteid INT
AS

BEGIN TRANSACTION
DECLARE @ErrorCode INT

UPDATE Forums SET SiteID = @newsiteid, LastUpdated = GETDATE() WHERE forumID = @forumid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
	VALUES(@forumid, getdate())
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION