CREATE PROCEDURE removecommenteditorpick @entryid INT
AS

DECLARE @ErrorCode INT

DELETE FROM threadentryeditorpicks WHERE entryid = @entryid 
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @curtime datetime
SET @curtime = CURRENT_TIMESTAMP;

UPDATE ThreadEntries SET lastupdated = @curtime WHERE entryid = @entryid
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Update Thread Last Updated.
DECLARE @threadid INT
SELECT @threadid = threadid FROM ThreadEntries WHERE entryid = @entryid
UPDATE Threads SET LastUpdated = @curtime 
	WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Update Forum LastUpdated avoiding hotspots in Forum table.
DECLARE @forumid INT
SELECT @forumid = forumid FROM Threads WHERE threadid = @threadid
INSERT INTO ForumLastUpdated (ForumID, LastUpdated) VALUES(@forumid, @curtime)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END