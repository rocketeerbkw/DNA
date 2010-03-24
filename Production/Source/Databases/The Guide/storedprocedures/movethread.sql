CREATE PROCEDURE movethread @threadid int, @forumid int
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

declare @oldforumid int
declare @postcount int
declare @negpostcount int
SELECT @oldforumid = ForumID, @postcount = ThreadPostCount, @negpostcount = -ThreadPostCount FROM Threads WITH(UPDLOCK) WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE Threads SET ForumID = @forumid, MovedFrom = @oldforumid, LastUpdated = getdate() WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE ThreadEntries SET ForumID = @forumid WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
	VALUES (@forumid, getdate())
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
	VALUES (@oldforumid, getdate())
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE ThreadPostings SET ForumID = @forumid WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE ThreadMod SET ForumID = @forumid WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE ThreadModOld SET ForumID = @forumid WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

--Update the ForumPostCount in both the old...
EXEC updateforumpostcount @oldforumid, NULL, @negpostcount
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

--- ...and the new forums
EXEC updateforumpostcount @forumid, NULL, @postcount
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION
