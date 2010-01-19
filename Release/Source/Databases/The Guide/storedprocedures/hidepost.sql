Create Procedure hidepost @postid int, @hiddenid int = 1
As

declare @forumid INT, @threadid INT
declare @parentid int

BEGIN TRANSACTION
DECLARE @ErrorCode INT

SELECT @forumid = ForumID, @threadid = ThreadID, @parentid = Parent 
	FROM ThreadEntries WITH(UPDLOCK) WHERE EntryID = @postid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE ThreadEntries SET Hidden = @hiddenid WHERE EntryID = @postid
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

UPDATE Threads WITH(HOLDLOCK) SET LastUpdated = getdate() WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

IF (@parentid IS NULL)
BEGIN
	-- Do something about the firstsubject because the initial post has been hidden
	UPDATE Threads SET FirstSubject = '' WHERE ThreadID = @threadid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

DECLARE @siteid INT
SELECT @siteid = siteid FROM Forums WHERE forumid = @forumid


-- Don't hide thread where only 1 thread per forum - forumstyle = 1
IF ( NOT EXISTS ( SELECT * FROM forums WHERE forumid = @forumid AND forumstyle=1) )
BEGIN
	-- Hide Thread if no further posts.
	IF NOT EXISTS (SELECT * FROM ThreadEntries WHERE ThreadID = @threadid AND HIDDEN IS NULL)
	BEGIN
		UPDATE Threads SET VisibleTo = 1 WHERE ThreadID = @threadid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
END


SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

COMMIT TRANSACTION

return (0)