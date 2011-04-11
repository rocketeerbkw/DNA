CREATE PROCEDURE createpremodpostingentry @modid int, @updatethreaddate int, @threadid int OUTPUT, @entryid int OUTPUT
AS
-- Double check to make sure we've been called inside a transaction!
IF (@@TRANCOUNT < 1)
BEGIN
	RAISERROR('createpremodpostingentry - Called outside of TRANSACTION!!!',16,1)
	RETURN 50000
END

DECLARE @UserID int, @ForumID int, @InreplyTo int, @Subject nvarchar(255),
		@PostStyle tinyint, @Hash uniqueidentifier, @Keywords varchar(255), @Nickname nvarchar(255), @Type int, @EventDate datetime,
		@ClubID int, @NodeID int, @IPAddress varchar(15), @DatePosted datetime, @ThreadRead tinyint, @ThreadWrite tinyint, @SiteID int,
		@AllowEventEntries tinyint,	@CurTime datetime, @ErrorCode int, @bbcuid uniqueidentifier, @IsComment tinyint,
		@riskmodthreadentryqueueid int

-- Get the values from the PreModPostings table for the given mod post.
SELECT	@CurTime = GetDate(),
		@UserID = UserID,
		@ThreadID = ThreadID,
		@ForumID = ForumID,
		@InReplyTo = InReplyTo,
		@Subject = Subject,
		@PostStyle = PostStyle,
		@Hash = Hash,
		@Keywords = Keywords,
		@Nickname = Nickname,
		@Type = Type,
		@EventDate = EventDate,
		@ClubID = ClubID,
		@NodeID = NodeID,
		@IPAddress = IPAddress,
		@DatePosted = DatePosted,
		@ThreadRead = ThreadRead,
		@ThreadWrite = ThreadWrite,
		@SiteID = SiteID,
		@AllowEventEntries = AllowEventEntries,
		@bbcuid = BBCUID,
		@IsComment = IsComment,
		@riskmodthreadentryqueueid = RiskModThreadEntryQueueId
	FROM dbo.PreModPostings WITH(NOLOCK)
	WHERE ModID = @ModID

-- Check to make sure we actually got an entry
IF (@UserID IS NULL)
BEGIN
	RAISERROR('createpremodpostingentry - Invalid ModID Given',16,1)
	RETURN 50000
END

declare @forumstyle int
select @forumstyle = ForumStyle from dbo.Forums WITH(NOLOCK) where ForumID = @forumid

if (@inreplyto IS NULL and (@IsComment = 1 OR @forumstyle = 1))
BEGIN
-- check to see if there's already a thread in this forum
	SELECT @threadid = te.threadid, 
			@inreplyto = te.entryid,
			@subject = ISNULL(f.title,'')
			FROM ThreadEntries te
			INNER JOIN Forums f ON f.ForumId = te.ForumId
			WHERE f.forumid = @forumid AND te.PostIndex = 0

END

-- Are we creating a new thread or replying to one?
IF (@InReplyTo IS NULL)
BEGIN
	/* We're starting a new thread but only if this isn't a comment 
	   If it's a comment, we check to see if we've already created a thread, and use that one */
	INSERT INTO dbo.Threads (ForumID, keywords, FirstSubject, VisibleTo, CanRead, CanWrite, Type, EventDate, LastPosted, LastUpdated) 
		SELECT @ForumID, @Keywords, '', 1, ThreadCanRead, ThreadCanWrite, @Type, @EventDate, @CurTime, @CurTime
			FROM Forums WITH(NOLOCK) WHERE ForumID = @ForumID
	SELECT @ErrorCode = @@ERROR
	SELECT @ThreadID = SCOPE_IDENTITY()
	IF (@ErrorCode <> 0)
	BEGIN
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	-- Insert any necessary extra permissions
	INSERT INTO dbo.ThreadPermissions (ThreadID, TeamID, CanRead, CanWrite, Priority)
	SELECT @ThreadID, TeamID, CanRead, CanWrite, Priority FROM dbo.ForumPermissions WITH(NOLOCK)
		WHERE ForumID = @ForumID
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	-- Now see if the posting user requires special permission to read/write the thread
	IF (@ThreadRead = 0 OR @ThreadWrite = 0)
	BEGIN
		IF NOT EXISTS ( SELECT * FROM dbo.ThreadPermissions t WITH(NOLOCK) 
						INNER JOIN dbo.TeamMembers m WITH(NOLOCK) ON t.TeamID = m.TeamID
						INNER JOIN dbo.Users u WITH(NOLOCK) ON m.UserID = u.UserID
						WHERE u.UserID = @UserID AND t.ThreadID = @ThreadID
							AND t.CanRead = 1 AND t.CanWrite = 1 )
		BEGIN
			INSERT INTO dbo.ThreadPermissions (ThreadID, TeamID, CanRead, CanWrite, Priority)
				SELECT @ThreadID, TeamID, 1, 1, 2
					FROM dbo.UserTeams WITH(NOLOCK) WHERE UserID = @UserID AND SiteID = @siteid
			SELECT @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				EXEC Error @ErrorCode
				RETURN @ErrorCode
			END
		END
	END
END
ELSE
BEGIN
	-- Update the threads LastPosted and LastUpdated
	UPDATE dbo.Threads SET LastPosted = CASE WHEN @updatethreaddate = 1 THEN @curtime ELSE LastPosted END, LastUpdated = @CurTime
		WHERE ThreadID = @ThreadID
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

DECLARE @LastReply int, @Parent int, @PostCount int
IF (@InReplyTo IS NOT NULL)
BEGIN
	-- Get the LastReply
	SELECT @LastReply = EntryID FROM dbo.ThreadEntries WITH(UPDLOCK) 
		WHERE NextSibling IS NULL AND Parent = @InReplyTo
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	-- Get new post count
	SELECT @PostCount = MAX(PostIndex)+1 FROM dbo.ThreadEntries WITH(UPDLOCK) 
		WHERE ThreadID = @ThreadID
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
ELSE
BEGIN
	-- It's a new thread, so no posts!
	SELECT @PostCount = 0
END

-- Create the new Thread Entry
INSERT INTO dbo.ThreadEntries ( ThreadID, blobid, text, ForumID, UserID, Subject, 
								UserName, DatePosted, Hidden, PostIndex, PostStyle, LastUpdated )
		SELECT @ThreadID, 0, Body, ForumID, UserID, Subject, Nickname, DatePosted, 3, @PostCount, PostStyle, @CurTime
			FROM dbo.PreModPostings WITH(NOLOCK) WHERE ModID = @ModID
SELECT @ErrorCode = @@ERROR
SELECT @EntryID = SCOPE_IDENTITY()
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Increment the post by thread counter for the specific thread
EXEC updatethreadpostcount @ThreadID, 1
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Increment relevent ForumPostCount by 1
EXEC updateforumpostcount @ForumID, NULL, 1
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Add the ipaddress if we have one
IF (@IPAddress IS NOT NULL)
BEGIN
	INSERT INTO dbo.ThreadEntriesIPAddress (EntryID, IPAddress, BBCUID) VALUES (@EntryID, @IPAddress, @bbcuid)
	-- No error checks.  Post should not fail if this fails
END

IF (@InReplyTo IS NOT NULL)
BEGIN
	/*
		Now we have to find out which record to attach to. 
		We're posting as a child of the post in @inreplyto - we must insert as the last child
		of the @inreplyto post. Therefore, we need to find a post whose NextSibling field is blank
		and whose Parent field is @inreplyto. If this is null, we're adding the first child
	*/
	IF (@LastReply IS NULL)
	BEGIN
	/* add this post as firstchild */
		UPDATE dbo.ThreadEntries SET Parent = @InReplyTo WHERE EntryID = @EntryID
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		UPDATE dbo.ThreadEntries SET FirstChild = @EntryID WHERE EntryID = @InReplyTo
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
	ELSE
	BEGIN
		/* Add post as last sibling */
		UPDATE dbo.ThreadEntries SET PrevSibling = @LastReply, Parent = @InReplyTo WHERE EntryID = @EntryID
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		UPDATE dbo.ThreadEntries SET NextSibling = @EntryID WHERE EntryID = @LastReply
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
END

-- Update the forums last updated param
INSERT INTO dbo.ForumLastUpdated (ForumID, LastUpdated) VALUES (@ForumID, @CurTime)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Add a ThreadPosting entry for the user
IF NOT EXISTS (SELECT * FROM dbo.ThreadPostings WITH(NOLOCK) WHERE UserID = @UserID AND ThreadID = @ThreadID)
BEGIN
	IF (@IsComment = 0)
	BEGIN
		INSERT INTO dbo.ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, 
										ForumID, Replies, CountPosts, Private)
			VALUES (@UserID, @ThreadID, @CurTime, @CurTime, @ForumID, 0,
					CASE WHEN @InReplyTo IS NULL THEN 1 ELSE @PostCount END,
					CASE WHEN @ThreadRead = 1 THEN 0 ELSE 1 END)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
END

-- Update the previously posted PostDuplicates table entry
UPDATE dbo.PostDuplicates SET ThreadID = @ThreadID, PostID = @EntryID WHERE HashValue = @Hash

-- Add an entry to the queue to allow the processor to work
INSERT INTO ThreadPostingsQueue (EntryID) VALUES(@entryid)

-- Update the users last posted
-- BUGFIX: Don't do this here, as it could be hours since the user actually posted
--EXEC updateuserlastposted @UserID, @SiteID

-- Update the ThreadMod Entry so it now knows about the new entry just created	
UPDATE dbo.ThreadMod SET PostID = @EntryID, ThreadID = @ThreadID, IsPreModPosting = 0 WHERE ModID = @ModID
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- Remove the entry from the PreModPosting Table
DELETE FROM dbo.PreModPostings WHERE ModID = @ModID
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

-- If we're allowed, then insert the event into the event table
IF (@AllowEvententries > 0)
BEGIN
	-- Add events, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC createpostingevents @userid, @forumid, @inreplyto, @threadid, @entryid
END

-- Update the ZietGiest if we're not a private message.
IF NOT EXISTS (SELECT ForumID FROM dbo.Teams t WITH(NOLOCK) INNER JOIN dbo.UserTeams u WITH(NOLOCK) ON u.TeamID = t.TeamID WHERE t.ForumID = @ForumID) -- i.e. the forum is not a user's private message forum
BEGIN
	-- update content signif. We don't want zeitgeist to fail this procedure so sp's error codes are not processed.
	DECLARE @GuideEntry_EntryID INT 
	SELECT @GuideEntry_EntryID = EntryID
		FROM dbo.GuideEntries WITH(NOLOCK)
		WHERE ForumID = @forumid

	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'PostToForum',
												@siteid	= @siteid, 
												@nodeid	= @nodeid, 
												@entryid = @GuideEntry_EntryID, 
												@userid	= @userid, 
												@threadid = @threadid, 
												@forumid = @forumid, 
												@clubid	= @clubid
END

-- If this was created via the riskmod system, update the RiskModThreadEntryQueue row so it ties up with
-- the new post
IF @riskmodthreadentryqueueid IS NOT NULL
BEGIN
	UPDATE RiskModThreadEntryQueue SET ThreadID=@threadid, ThreadEntryId=@EntryID WHERE RiskModThreadEntryQueueId=@riskmodthreadentryqueueid
END

-- If we got here, then everything went ok, return success!
RETURN 0