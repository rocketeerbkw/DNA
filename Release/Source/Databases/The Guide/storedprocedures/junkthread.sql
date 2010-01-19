Create Procedure junkthread @threadid int
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

declare @forumid int, @postcount int
SELECT @forumid = ForumID, @postcount = ThreadPostCount FROM Threads WITH(UPDLOCK) WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE ThreadEntries SET ForumID = 1, Hidden = 1 WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE Threads SET ForumID = 1, MovedFrom = @forumid, LastUpdated = getdate(), VisibleTo = 1 WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

--UPDATE Forums SET LastUpdated = getdate() WHERE ForumID = @forumid
INSERT INTO ForumLastUpdated (ForumID, LastUpdated) VALUES(@forumid, getdate())
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

DELETE FROM ThreadPostings WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @negpostcount int
set @negpostcount = -@postcount
--Update the ForumPostCount on both the specified forum...
EXEC updateforumpostcount @forumid, NULL, @negpostcount
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- ...and the forum the threads have been junked to
EXEC updateforumpostcount @forumid = 1, @difference = @postcount
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)