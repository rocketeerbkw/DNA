Create Procedure posttojournal @userid int, @journal int, @subject nvarchar(255), 
	@nickname nvarchar(255), @content nvarchar(max), @siteid int, @poststyle int, @hash uniqueidentifier,
	@forcemoderation TinyInt = 0, @ignoremoderation tinyint = 0,  @ipaddress varchar(25) = null,
	@bbcuid uniqueidentifier = NULL

AS
declare @curtime datetime
SELECT @curtime = getdate()

BEGIN TRANSACTION
DECLARE @ErrorCode INT

INSERT INTO PostDuplicates (HashValue, DatePosted, ForumID, ThreadID, Parent, UserID)
VALUES(@hash, @curtime, @journal, NULL, NULL, @userid)
IF @@ROWCOUNT = 0
BEGIN
	ROLLBACK TRANSACTION
	SELECT 'ForumID' = @journal, 'ThreadID' = ThreadID, 'PostID' = PostID FROM PostDuplicates WHERE HashValue = @hash
	return(0)
END


IF @subject IS NOT NULL
BEGIN
	SELECT @subject = REPLACE(@subject, '<', '&lt;')
	SELECT @subject = REPLACE(@subject, '>', '&gt;')
END

IF (@journal IS NULL)
BEGIN
/*	We're starting a new journal 
	For journal forums, JournalOwner = the ID of the user
	for non-journal forums, it's NULL
*/
	INSERT INTO Forums (Title, JournalOwner, SiteID, CanRead, CanWrite, ThreadCanRead, ThreadCanWrite) 
		VALUES('User-journal', @userid, @siteid, 1, 0, 1, 1)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	SELECT @journal = @@IDENTITY
	
	UPDATE Users SET Journal = @journal WHERE UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	INSERT INTO ForumPermissions (TeamID, ForumID, CanRead, CanWrite)
	SELECT TeamID, @journal, 1,1 FROM UserTeams WHERE userID = @userid AND SiteID = @siteid
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
ELSE
BEGIN
--	UPDATE Forums SET LastPosted = @curtime, LastUpdated = @curtime 
--	WHERE ForumID = @journal
	INSERT INTO ForumLastUpdated (ForumID, LastUpdated)
		VALUES (@journal, @curtime)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

declare @premoderation int, @unmoderated int, @threadid int
if (@ignoremoderation = 1)
BEGIN
		-- ignore moderation (usually because it's being updated by an editor)
		SELECT @premoderation = 0, @unmoderated = 1, @forcemoderation = 0
END
ELSE
BEGIN
	-- Get Mod Status for User/Forum/Site - (threadid is optional).
	EXEC getmodstatusforforum @userid,@threadid,@journal,@siteid,@premoderation OUTPUT, @unmoderated OUTPUT

	IF (@forcemoderation = 1)
	BEGIN
		-- We *shouldn't* premoderate items when the forcemoderate flag is set - this should only put an entry into the mod queue
		-- remoiving the @premoderation = 1 fixes journals going missing due to the profanity filter
		--SELECT @premoderation = 1
		SELECT @unmoderated = 0
	END
END

INSERT INTO Threads (ForumID, FirstSubject, VisibleTo, LastPosted, LastUpdated) 
VALUES (@journal, CASE WHEN @premoderation = 1 THEN '' ELSE @subject END, 
		CASE WHEN @premoderation = 1 THEN 1 ELSE NULL END,
		@curtime, @curtime )
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END
SELECT @threadid = @@IDENTITY

INSERT INTO ThreadEntries (ThreadID, blobid, text, ForumID, UserID, Subject, UserName, Hidden, PostStyle)
	VALUES(@threadid, 0, @content, @journal, @userid, @subject, @nickname, CASE WHEN @premoderation = 1 THEN 3 ELSE NULL END, @poststyle)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @entryid int
SELECT @entryid = @@IDENTITY
--increment the post by thread counter for the specific thread
EXEC updatethreadpostcount @threadid, 1
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

--Increment relevent ForumPostCount by 1
EXEC updateforumpostcount @journal, NULL, 1
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END


INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, LastUserPostID, ForumID, Replies, CountPosts)
	--VALUES(@userid, @threadid, @curtime, @curtime, @entryid, @journal, 0, 1)
	SELECT UserID, @threadid, @curtime, NULL, NULL, @journal,1,1
	FROM FaveForums WHERE ForumID = @journal AND UserID <> @userid
	UNION
	SELECT @userid, @threadid, @curtime, @curtime, @entryid, @journal,0,1
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

IF (@ipaddress IS NOT NULL)
BEGIN
	INSERT INTO ThreadEntriesIPAddress (EntryID, IPAddress, BBCUID) VALUES (@entryid,@ipaddress,@bbcuid)
	-- No error checks.  Post should not fail if this fails
END

--UPDATE Threads SET LastPosted = @curtime, LastUpdated = @curtime WHERE ThreadID = @threadid
--SELECT @ErrorCode = @@ERROR
--IF (@ErrorCode <> 0)
--BEGIN
--	ROLLBACK TRANSACTION
--	EXEC Error @ErrorCode
--	RETURN @ErrorCode
--END

-- If moderated in some way, add to the ThreadMod table
IF (@unmoderated = 0)
BEGIN
	INSERT INTO ThreadMod (ForumID, ThreadID, PostID, Status, NewPost, SiteID)
		VALUES(@journal, @threadid, @entryid, 0, 1, @siteid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

UPDATE PostDuplicates SET ThreadID = @threadid, PostID = @entryid WHERE HashValue = @hash

COMMIT TRANSACTION

SELECT 'ForumID' = @journal, 'ThreadID' = @threadid, 'PostID' = @entryid
