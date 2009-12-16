Create Procedure pruneforum @forumid int, @threadid int, @postid int, @newforumid int = 16034
As

declare @thispost int
SELECT @thispost = @postid

/*
We want to remove this post and all its children from the tree
It could be linked in three ways:
	First child (first sibling)
	Middle sibling
	Last child (end sibling)

if there's a previous sibling, point its next pointer at this one's next
if there's a next sibling, point its
*/

-- get the info from this post
declare @prevsibling int, @nextsibling int, @parent int, @subject nvarchar(255), @child int


SELECT @prevsibling = PrevSibling, @nextsibling = NextSibling, @parent = Parent, @subject = Subject
	FROM ThreadEntries
	WHERE EntryID = @postid

BEGIN TRANSACTION
DECLARE @ErrorCode INT

IF @prevsibling IS NULL
BEGIN
	IF @nextsibling IS NULL
	BEGIN
		-- no next sibling, just clear the parent's child pointer
		UPDATE ThreadEntries SET FirstChild = NULL WHERE EntryID = @parent
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
		-- Oops - there is a next sibling, so fix that and its parent
		UPDATE ThreadEntries SET FirstChild = @nextsibling WHERE EntryID = @parent
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		UPDATE ThreadEntries SET PrevSibling = NULL WHERE EntryID = @nextsibling
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
	-- There is a previous sibling so we don't need to worry about the parent
	UPDATE ThreadEntries SET NextSibling = @nextsibling WHERE EntryID = @prevsibling
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ThreadEntries SET PrevSibling = @prevsibling WHERE EntryID = @nextsibling
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

-- That's detached the post and all its children from the tree
-- Now to isolate it
UPDATE ThreadEntries WITH(HOLDLOCK) SET NextSibling = NULL, PrevSibling = NULL, Parent = NULL
	WHERE EntryID = @postid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- And create a new Thread
INSERT INTO Threads (ForumID, FirstSubject) VALUES(@newforumid,@subject)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END
declare @newthreadid int
SELECT @newthreadid = @@IDENTITY

-- Now to update all posts to be in the new thread
WHILE @thispost IS NOT NULL
BEGIN

	--get threadid of record about to be updated
	DECLARE @iOldThreadID INT
	SELECT @iOldThreadID = ThreadID FROM ThreadEntries WHERE EntryID = @thispost
	
	UPDATE ThreadEntries SET ThreadID = @newthreadid, ForumID = @newforumid
		WHERE EntryID = @thispost
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	--decrement the post by thread counter of old thread
	EXEC updatethreadpostcount @iOldThreadID, -1
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	--increment the post by thread counter of new thread
	EXEC updatethreadpostcount @newthreadid, 1
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	SELECT @nextsibling = NextSibling, @parent = Parent, @child = FirstChild
		FROM ThreadEntries WITH(UPDLOCK)
		WHERE EntryID = @thispost
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- Get the next post
	-- If there's a child, use it
	IF @child IS NOT NULL
	BEGIN
		SELECT @thispost = @child
		CONTINUE
	END
	IF @nextsibling IS NOT NULL
	BEGIN
		SELECT @thispost = @nextsibling
		CONTINUE
	END
	-- go up the parent tree and find the next sibling
	SELECT @thispost = @parent
	SELECT @nextsibling = NextSibling, @parent = Parent, @child = FirstChild
		FROM ThreadEntries WITH(UPDLOCK)
		WHERE EntryID = @thispost
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	WHILE @nextsibling IS NULL AND @parent IS NOT NULL
	BEGIN
		SELECT @thispost = @parent
		SELECT @nextsibling = NextSibling, @parent = Parent, @child = FirstChild
			FROM ThreadEntries WITH(UPDLOCK)
			WHERE EntryID = @thispost
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
	IF @nextsibling IS NOT NULL
	BEGIN
		SELECT @thispost = @nextsibling
		CONTINUE
	END
	BREAK
END

UPDATE Threads SET LastUpdated = getdate(), LastPosted = (SELECT MAX(DatePosted) FROM ThreadEntries WHERE ThreadID = @newthreadid)
	WHERE ThreadID = @newthreadid OR ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Make copies of the rows in ThreadPostings for the new thread
INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, ForumID, Replies, CountPosts)
	SELECT UserID, @newthreadid, LastPosting, LastUserPosting, @newforumid, Replies, CountPosts
	FROM ThreadPostings t WHERE t.ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE ThreadPostings WITH(HOLDLOCK)
	SET LastPosting = 
		( SELECT MAX(DatePosted) FROM ThreadEntries t WHERE t.ThreadID = ThreadPostings.ThreadID),
	LastUserPosting = 
		( SELECT MAX(DatePosted) FROM ThreadEntries t WHERE t.ThreadID = ThreadPostings.ThreadID AND t.UserID = ThreadPostings.UserID),
	LastUserPostID =
		(SELECT MAX(EntryID) FROM ThreadEntries t WHERE t.ThreadID = ThreadPostings.ThreadID AND t.UserID = ThreadPostings.UserID),
	CountPosts = 
		( SELECT COUNT(*) FROM ThreadEntries t WHERE t.ThreadID = ThreadPostings.ThreadID)
	WHERE ThreadID = @newthreadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

UPDATE ThreadPostings
	Set Replies = CASE WHEN LastUserPosting = LastPosting THEN 0 ELSE 1 END
	WHERE ThreadID = @newthreadid			
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

EXEC updateforumpostcount @forumid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END


COMMIT TRANSACTION

SELECT 'ForumID' = @newforumid, 'ThreadID' = @newthreadid

return (0)
