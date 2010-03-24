Create Procedure unhidepost @postid int
As

BEGIN TRANSACTION
DECLARE @ErrorCode INT

UPDATE ThreadEntries SET Hidden = NULL WHERE EntryID = @postid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @parent int, @threadid int, @forumid int, @subject nvarchar(255)
SELECT @parent = Parent,@forumid = ForumID,  @threadid = ThreadID, @subject = Subject FROM ThreadEntries 
	WHERE EntryID = @postid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

IF @parent IS NULL
BEGIN
	UPDATE Threads WITH(HOLDLOCK)
		SET FirstSubject = @subject
		WHERE ThreadID = @ThreadID
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

UPDATE Threads SET VisibleTo = NULL, LastUpdated = getdate() WHERE ThreadID = @threadid
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

COMMIT TRANSACTION

return (0)