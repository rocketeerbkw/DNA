CREATE PROCEDURE createcommenteditorpick @entryid INT
AS

DECLARE @ErrorCode INT

-- Can only have one editor pick per comment.
IF EXISTS ( SELECT * FROM threadentryeditorpicks WHERE entryid = @entryid ) 
BEGIN
	RETURN 0
END

INSERT INTO threadentryeditorpicks 
select @entryid, forumid from threadentries where entryid=@entryid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END


declare @curtime datetime
SET @curtime = CURRENT_TIMESTAMP;

-- Update Thread Entry last updated.
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

