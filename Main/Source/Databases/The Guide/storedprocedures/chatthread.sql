Create Procedure chatthread @threadid int
As

declare @forumid int
SELECT @forumid = ForumID FROM Threads WHERE ThreadID = @threadid

BEGIN TRANSACTION
DECLARE @ErrorCode INT

UPDATE ThreadEntries SET ForumID = 16034 WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE Threads SET ForumID = 16034, MovedFrom = @forumid WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

--Update the ForumPostCount on the Forum moved from
EXEC updateforumpostcount @ForumID
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

--And update on the Forum moved to.
EXEC updateforumpostcount 16034
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)
