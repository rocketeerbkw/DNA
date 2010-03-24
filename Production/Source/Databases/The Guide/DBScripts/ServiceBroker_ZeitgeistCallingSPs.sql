/**********************************************/
/***************	CALLING SPs		***********/
/**********************************************/

-- POSTTOFORUMINTERNAL - check that PostToForumInternal has not changed since this was taken 2007-07-27
CREATE PROCEDURE posttoforuminternal @userid int, 
										@forumid int, 
										@inreplyto int, 
										@threadid int, 
										@subject varchar(255), 
										@content text, 
										@poststyle int, 
										@hash uniqueidentifier, 
										@keywords varchar(255), 
										@nickname varchar(255) = NULL, 
										@returnthread int OUTPUT, 
										@returnpost int OUTPUT, 
										@type varchar(30) = NULL, 
										@eventdate datetime = NULL,
										@forcemoderate tinyint = 0, 
										@forcepremoderation tinyint = 0,
										@ignoremoderation tinyint = 0, 
										@allowevententries tinyint = 1, 
										@nodeid int = 0, 
										@ipaddress varchar(25) = null,
										@queueid int  = NULL, 
										@clubid int = 0, 
										@ispremodposting int OUTPUT,
										@ispremoderated int OUTPUT, 
										@bbcuid uniqueidentifier = NULL,
										@isnotable tinyint = 0, 
										@iscomment tinyint = 0

	
AS
declare @curtime datetime
DECLARE @privmsg 	INT
SELECT @curtime = getdate()
DECLARE @ErrorCode INT

IF ISNULL(@inreplyto,0) = 0 AND EXISTS(SELECT * FROM ThreadEntries WITH(NOLOCK) WHERE DatePosted > DATEADD(minute,-1,getdate()) AND UserID = @userid AND ForumID = @forumid)
BEGIN
	select @returnthread = 0, @returnpost = 0
	return (0)
END
-- Get some info from the Forums table that we'll need later.
declare @journalowner int, @siteid int
SELECT @journalowner = JournalOwner, @siteid = siteid FROM Forums WITH(NOLOCK) WHERE ForumID = @forumid

declare @premoderation int, @unmoderated int
if (@ignoremoderation = 1)
BEGIN
	-- ignore moderation (usually because it's being updated by an editor)
	SELECT @premoderation = 0, @unmoderated = 1, @forcemoderate = 0
END
ELSE IF (@forcepremoderation = 1 )
BEGIN
	-- Post is to have forced premoderation .
	SELECT @premoderation = 1, @unmoderated = 0, @forcemoderate = 0
END
ELSE
BEGIN
	-- Determine Modersation status.
	-- Get the premoderated & unmoderated states for site/forum/thread/user
	exec getmodstatusforforum @userid,@threadid,@forumid,@siteid,@premoderation OUTPUT,@unmoderated OUTPUT

	IF (@isnotable = 1 AND @premoderation = 1)
	BEGIN
		SET @premoderation = 0
		SET @unmoderated = 0	
	END
	ELSE
	BEGIN
		--Check to see if moderation is being forced ( Profanity/URL/First Post ).
		IF (@forcemoderate = 1)
		BEGIN
			SET @unmoderated = 0
		END
	END
END

select @returnthread = 0, @returnpost = 0, @ispremoderated = @premoderation

if @forumid = 0
BEGIN
	return (0)
END

-- see if this is a duplicate post
/*
declare @exthreadid int, @expostid int
IF (@inreplyto IS NULL)
BEGIN
	SELECT TOP 1 @exthreadid = ThreadID, @expostid = EntryID
		FROM ThreadEntries t
		INNER JOIN blobs b ON t.blobid = b.blobid
		WHERE Parent IS NULL AND ForumID = @forumid AND UserID = @userid
		AND b.text like @content
END
ELSE
BEGIN
	SELECT TOP 1 @exthreadid = ThreadID, @expostid = EntryID
		FROM ThreadEntries t
		INNER JOIN blobs b ON t.blobid = b.blobid
		WHERE Parent = @inreplyto AND ForumID = @forumid AND UserID = @userid
		AND b.text like @content
END 

IF (@exthreadid IS NOT NULL)
BEGIN
SELECT @returnthread = @exthreadid, @returnpost = @expostid
return (0)
END
*/

-- TODO: Change this to use real permissions, not implicit rules
IF ((@journalowner IS NOT NULL) AND (@inreplyto IS NULL OR @inreplyto = 0))
BEGIN
	return (0)
END
declare @threadread int, @threadwrite int
IF @inreplyto IS NULL
BEGIN
select @threadread = ThreadCanRead, @threadwrite = ThreadCanWrite
	FROM Forums WITH(NOLOCK) WHERE ForumID = @forumid
END
ELSE
BEGIN
select @threadread = CanRead, @threadwrite = CanWrite
	FROM Threads WITH(NOLOCK) WHERE ThreadID = @threadid
END


BEGIN TRANSACTION
--declare @dummy int
--select @dummy = ForumID from forums WITH(UPDLOCK) where ForumID = @forumid

-- fix the PostIndex stuff
/*
IF @inreplyto IS NOT NULL
BEGIN
UPDATE ThreadEntries
	SET PostIndex = (SELECT COUNT(*) FROM ThreadEntries t WHERE t.ThreadID = ThreadEntries.ThreadID AND t.EntryID < ThreadEntries.EntryID)
	WHERE ThreadID = @threadid AND PostIndex IS NULL
END
*/

BEGIN TRY

-- First see if we can insert the hash at all
-- later we have to update it with the actual values (like ThreadID etc.)
INSERT INTO PostDuplicates (HashValue, DatePosted, ForumID, ThreadID, Parent, UserID)
VALUES(@hash, @curtime, @forumid, @threadid, @inreplyto, @userid)
IF @@ROWCOUNT = 0
BEGIN
	ROLLBACK TRANSACTION
	SELECT @returnthread = ThreadID, @returnpost = PostID FROM PostDuplicates WHERE HashValue = @hash
	return(0)
END

END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT @returnthread = ThreadID, @returnpost = PostID FROM PostDuplicates WHERE HashValue = @hash
	--return ERROR_NUMBER()
	return (0) -- This error is expected for duplicate posts.
END CATCH

/*
	Check to see if the site has the process premod messages set. This basically means that the post will not
	be inserted into the threads table untill it has passed moderation.
*/
IF ( @premoderation = 1 AND EXISTS (SELECT * FROM dbo.SiteOptions so WHERE so.SiteID = @siteid AND so.Section = 'Moderation' AND so.Name = 'ProcessPreMod' AND so.Value = '1') )
BEGIN
	-- Create a ThreadMod Entry and get it's ModID
	DECLARE @ModID INT
	INSERT INTO ThreadMod (ForumID, ThreadID, PostID, Status, NewPost, SiteID, IsPreModPosting)
		VALUES (@forumid, @threadid, 0, 0, 1, @siteid, 1)
	SELECT @ModID = @@IDENTITY
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	-- Now insert the values into the PreModPostings tables
	INSERT INTO dbo.PreModPostings (ModID, UserID, ForumID, ThreadID, InReplyTo, Subject, Body,
									PostStyle, Hash, Keywords, Nickname, Type, EventDate,
									ClubID, NodeID, IPAddress, ThreadRead, ThreadWrite, SiteID, AllowEventEntries, BBCUID, IsComment)
		VALUES (@ModID, @userid, @forumid, @threadid, @inreplyto, @subject, @content,
				@poststyle, @hash, @keywords, @nickname, @type, @eventdate,
				@clubid, @Nodeid, @ipaddress, @threadread, @threadwrite, @SiteID, @AllowEventEntries, @bbcuid, @IsComment)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	-- mark that the user has posted already so that we don't have to do it in the createpremodentry proc
	EXEC updateuserlastposted @userid,@siteid
	-- COMMIT and Now Set the IsPreModPosting flag and return
	COMMIT TRANSACTION
	SET @ispremodposting = 1
	RETURN 0
END

IF (@inreplyto IS NULL)
BEGIN


	/* We're starting a new thread */
	INSERT INTO Threads (ForumID, keywords, FirstSubject, VisibleTo, CanRead, CanWrite, Type, EventDate, LastPosted, LastUpdated) 
		SELECT @forumid, @keywords, 
				CASE WHEN @premoderation = 1 THEN '' ELSE @subject END, 
				CASE WHEN @premoderation = 1 THEN 1 ELSE NULL END,
				ThreadCanRead, ThreadCanWrite, @type, @eventdate, @curtime, @curtime
				FROM Forums WITH(NOLOCK) WHERE ForumID = @forumid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	SELECT @threadid = @@IDENTITY
	-- Insert any necessary extra permissions
	INSERT INTO ThreadPermissions (ThreadID, TeamID, CanRead, CanWrite, Priority)
	SELECT @threadid, TeamID, CanRead, CanWrite, Priority FROM ForumPermissions
		WHERE ForumID = @forumid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
	
	-- Now see if the posting user requires special permission to read/write the thread
	if (@threadread = 0 OR @threadwrite = 0)
	BEGIN
		IF NOT EXISTS (SELECT * FROM ThreadPermissions t 
						INNER JOIN TeamMembers m ON t.TeamID = m.TeamID
						INNER JOIN Users u ON m.UserID = u.UserID
						WHERE u.UserID = @userid AND t.ThreadID = @threadid
							AND t.CanRead = 1 AND t.CanWrite = 1)
		BEGIN
			INSERT INTO ThreadPermissions (ThreadID, TeamID, CanRead, CanWrite, Priority)
				SELECT @threadid, TeamID, 1,1,2
					FROM UserTeams WHERE UserID = @userid AND SiteID = @siteid
			SELECT @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				EXEC Error @ErrorCode
				RETURN @ErrorCode
			END

		END
	END

END


UPDATE Threads SET LastPosted = @curtime, LastUpdated = @curtime 
	WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

declare @lastreply int, @parent int

declare @postcount int

IF (NOT (@inreplyto IS NULL))
BEGIN
	SELECT @lastreply = EntryID FROM ThreadEntries WITH(UPDLOCK) 
		WHERE NextSibling IS NULL AND Parent  = @inreplyto
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END
-- note the -1 below - this is because we've already added the new post, so COUNT(*)
-- will be accurate, but since we increment the count later, we have to subtract 1
-- to end up with the same result.

IF @inreplyto IS NULL
BEGIN
SELECT @postcount = 0
END
ELSE
BEGIN
SELECT @postcount = MAX(PostIndex)+1 FROM ThreadEntries WITH(UPDLOCK) 
	WHERE ThreadID = @threadid -- AND (Hidden IS NULL)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END
END


IF @queueid IS NULL
BEGIN
	INSERT INTO ThreadEntries (ThreadID, blobid, text, ForumID, UserID, Subject, 
								UserName, DatePosted, Hidden, PostIndex, PostStyle, LastUpdated)
		VALUES(@threadid, 0, @content, @forumid, @userid, @subject, @nickname, 
				@curtime, CASE WHEN (@premoderation = 1) THEN 3 ELSE NULL END, @postcount, @poststyle, @curtime)
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
	INSERT INTO ThreadEntries (ThreadID, blobid, text, ForumID, UserID, Subject, 
								UserName, DatePosted, Hidden, PostIndex, PostStyle, LastUpdated)
		SELECT @threadid, 0, content, @forumid, @userid, @subject, @nickname, 
				@curtime, CASE WHEN (@premoderation = 1) THEN 3 ELSE NULL END, @postcount, @poststyle, @curtime
			FROM PostingQueue
				WHERE QueueID = @queueid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
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
EXEC updateforumpostcount @forumid, NULL, 1
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

IF (NOT (@inreplyto IS NULL))
BEGIN
	/* Now we have to find out which record to attach to. 
	We're posting as a child of the post in @inreplyto - we must insert as the last child
	of the @inreplyto post. Therefore, we need to find a post whose NextSibling field is blank
	and whose Parent field is @inreplyto. If this is null, we're adding the first child
	*/
	--declare @lastreply int, @parent int
	--SELECT @lastreply = EntryID FROM ThreadEntries WHERE NextSibling IS NULL AND Parent  = @inreplyto
	IF (@lastreply IS NULL)
	BEGIN
	/* add this post as firstchild */
		UPDATE ThreadEntries SET Parent = @inreplyto WHERE EntryID = @entryid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		UPDATE ThreadEntries SET FirstChild = @entryid WHERE EntryID = @inreplyto
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
		/* Add post as last sibling */
		UPDATE ThreadEntries SET PrevSibling = @lastreply, Parent = @inreplyto WHERE EntryID = @entryid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END

		UPDATE ThreadEntries SET NextSibling = @entryid WHERE EntryID = @lastreply
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
END

INSERT INTO ForumLastUpdated (ForumID, LastUpdated) VALUES(@forumid, @curtime)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END

/*
-- removed to avoid hotspot in Forums table for LastUpdated
UPDATE Forums SET LastPosted = DEFAULT, LastUpdated = DEFAULT WHERE ForumID = @forumid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
END
*/

/*
	Note: We *only* insert the ThreadPostings entry for *this* user
	All other inserts and updates are done in the queue
*/

IF (@inreplyto IS NULL AND @IsComment = 0)
BEGIN
	INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, 
								ForumID, Replies, CountPosts, Private)
		VALUES(@userid, @threadid, @curtime, @curtime, @forumid,0,1, CASE WHEN @threadread = 1 THEN 0 ELSE 1 END)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
/*
	INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, 
								ForumID, Replies, CountPosts, Private)
		--VALUES(@userid, @threadid, @curtime, @curtime, @forumid, 0, 0)
		SELECT UserID, @threadid, @curtime, NULL, @forumid,0,0, CASE WHEN @threadread = 1 THEN 0 ELSE 1 END
			FROM FaveForums WHERE ForumID = @forumid AND UserID <> @userid
				AND (@threadread = 1 OR UserID IN (SELECT m.UserID FROM ThreadPermissions t INNER JOIN TeamMembers m ON t.TeamID = m.TeamID WHERE t.ThreadID = @threadid AND t.CanRead = 1))
		UNION
		SELECT @userid, @threadid, @curtime, NULL, @forumid,0,0, CASE WHEN @threadread = 1 THEN 0 ELSE 1 END
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
*/
END


IF NOT EXISTS (SELECT * FROM ThreadPostings WHERE UserID = @userid AND ThreadID = @threadid)
BEGIN
	IF (@IsComment = 0)
	BEGIN
		INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, 
									ForumID, Replies, CountPosts, Private)
			VALUES(@userid, @threadid, @curtime, @curtime, @forumid, 0, @postcount, CASE WHEN @threadread = 1 THEN 0 ELSE 1 END)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END
END

/*
	UPDATE ThreadPostings WITH(HOLDLOCK)
		SET LastPosting = @curtime, CountPosts = @postcount+1, Replies = 1
			WHERE ThreadID = @threadid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

	UPDATE ThreadPostings
		SET LastUserPosting = @curtime, Replies = 0, LastUserPostID = @entryid
			WHERE ThreadID = @threadid AND UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END

*/


IF (@unmoderated = 0)
BEGIN
	INSERT INTO ThreadMod (ForumID, ThreadID, PostID, Status, NewPost, SiteID)
		VALUES(@forumid, @threadid, @entryid, 0, 1, @siteid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		EXEC Error @ErrorCode
		RETURN @ErrorCode
	END
END

/*
	-- Update all other users intrested subscribed to this conversation if it is private
	-- We can assume that if the threadread=0, it must be a private thread
	IF @threadread = 0
	BEGIN
		UPDATE dbo.Users SET UnreadPrivateMessageCount = UnreadPrivateMessageCount + 1 WHERE UserID IN
		(
			SELECT UserID FROM dbo.ThreadPostings WHERE ThreadID = @ThreadID AND Private = 1
		)
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			EXEC Error @ErrorCode
			RETURN @ErrorCode
		END
	END

*/

-- update the previously posted PostDuplicates table entry
UPDATE PostDuplicates SET ThreadID = @threadid, PostID = @entryid WHERE HashValue = @hash

-- Add an entry to the queue to allow the processor to work
INSERT INTO ThreadEntryQueue (EntryID) VALUES(@entryid)

COMMIT TRANSACTION

EXEC updateuserlastposted @userid,@siteid

IF (@allowevententries > 0)
BEGIN
	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_FORUMEDITED', @ForumID, 'IT_FORUM', @threadid, 'IT_THREAD', @userid

	-- update the eventqueue
	IF (@inreplyto IS NULL)
	BEGIN
		-- New thread created
		EXEC addtoeventqueueinternal 'ET_POSTNEWTHREAD', @forumid, 'IT_FORUM', @threadid, 'IT_THREAD', @userid
	END
	ELSE
	BEGIN
		-- Thread has reply
		EXEC addtoeventqueueinternal 'ET_POSTREPLIEDTO', @threadid, 'IT_THREAD', @inreplyto, 'IT_POST', @userid
	END
END

	SELECT @privmsg = ForumID 
	  FROM dbo.Teams t WITH(NOLOCK)
	       INNER JOIN UserTeams u WITH(NOLOCK) ON u.TeamID = t.TeamID 
	 WHERE t.ForumID = @ForumID

	IF(@privmsg IS NULL) -- i.e. the forum is not a user's private message forum
	BEGIN
		-- update content signif. We don't want zeitgeist to fail this procedure so sp's error codes are not processed.
		DECLARE @GuideEntry_EntryID INT 
		 
		SELECT @GuideEntry_EntryID = EntryID
		  FROM dbo.GuideEntries WITH(NOLOCK)
		 WHERE ForumID = @forumid
	
--		EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'PostToForum',
--												  @siteid		= @siteid, 
--												  @nodeid		= @nodeid, 
--												  @entryid		= @GuideEntry_EntryID, 
--												  @userid		= @userid, 
--												  @threadid		= @threadid, 
--												  @forumid		= @forumid, 
--												  @clubid		= @clubid

		DECLARE @ZeitgeistEvent uniqueidentifier
		DECLARE @Message nvarchar(2500)

		SET @Message = N'<EVENT><DESCRIPTION>PostToForum</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID>><ENTRYID>'+CAST(@GuideEntry_EntryID as varchar(20))+'</ENTRYID><USERID>'+CAST(@userid as varchar(20))+'</USERID><THREADID>'+CAST(@threadid as varchar(20))+'</THREADID><FORUMID>'+CAST(@forumid as varchar(20))+'</FORUMID><CLUBID>'+CAST(@clubid as varchar(20))+'</CLUBID></EVENT>';
		
		BEGIN DIALOG CONVERSATION @ZeitgeistEvent
		  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
		  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
		  ON CONTRACT [//bbc.co.uk/dna/Zeitgeist_PostToForumContract]
		  WITH ENCRYPTION = OFF;

		SEND ON CONVERSATION @ZeitgeistEvent
		  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_PostToForum] (@Message)

	END

SELECT @returnthread = @threadid, @returnpost = @entryid

RETURN 0


-- CREATEGUIDEENTRYINTERNAL - check that createguideentryinternal has not changed since this was taken 2007-07-30
ALTER PROCEDURE [dbo].[createguideentryinternal]
@subject varchar(255), 
@bodytext varchar(max), 
@extrainfo text,
@editor int,
@style int = 1, 
@status int = NULL, 
@keywords varchar(255) = NULL,
@researcher int = NULL,
@siteid int = 1,
@submittable tinyint = 1,
@guidetypeid int, 
@returnentryid int OUTPUT,
@returndatecreated datetime OUTPUT,
@returnforumid int OUTPUT,
@returnh2g2id int OUTPUT,
@returnhaveduplicate tinyint OUTPUT,
@hash uniqueidentifier = NULL,
@preprocessed int = 1,
@canread tinyint = 1,
@canwrite tinyint = 0, 
@canchangepermissions tinyint = 0,
@forumstyle tinyint = 0,
@groupnumber int = NULL,
@ignoremoderation int = 0
AS

/*
	IMPORTANT!!!
	This Stored procedure should never be called directly as it doesn't do any TRANSACTION calls!
	Make sure the calling procedure calls this within BEGIN / COMMIT TRANSACTION calls
*/
IF (@@TRANCOUNT = 0)
BEGIN
	RAISERROR ('createguideentryinternal cannot be called outside a transaction!!!',16,1)
	RETURN 50000
END

if (NOT (@editor IS NULL))
BEGIN
	-- Check to see if we've been given a hash value to check against!
	IF (@hash IS NOT NULL)
	BEGIN
		-- Try to insert the new Hashvalue and details into the ArticleDuplicates table.
		INSERT INTO ArticleDuplicates ( HashValue, UserID ) VALUES (@hash, @editor)

		-- If no rows were effected, then we've already got this guideentry!!!
		IF (@@ROWCOUNT = 0)
		BEGIN
			-- Get the h2g2id from the duplicates table
			SELECT	@returnh2g2id = h2g2ID
				FROM ArticleDuplicates
				WHERE HashValue = @hash

			-- Make sure all the return details are set correctly
			SELECT	@returnentryid = EntryID,
					@returndatecreated = GetDate(),
					@returnforumid = ForumID,
					@returnhaveduplicate = 1
				FROM GuideEntries
				WHERE h2g2id = @returnh2g2id AND siteid = @siteid

			-- Return ok!
			return (0)
		END
	END

	declare @premoderation int
	SET @premoderation = 0
	
	-- Allow Moderation to be ignored. Editors / Superusers should not be moderated.
	IF ( @ignoremoderation <> 1 )
	BEGIN
		SELECT @premoderation = PreModeration FROM Sites WHERE SiteID = @siteid

		IF (@premoderation IS NULL OR @premoderation <> 1) AND EXISTS(SELECT * from Groups g
										INNER JOIN GroupMembers m ON g.GroupID = m.GroupID
										WHERE m.UserID = @editor
										AND g.Name = 'Premoderated'
										AND g.UserInfo = 1
										AND m.SiteID = @siteid)
		BEGIN
			SELECT @premoderation = 1
		END
		
		if (@premoderation <> 1)
		begin		
			declare @prefstatus int
			exec getmemberprefstatus @editor, @siteid, @prefstatus output
			if (@prefstatus = 1)
			begin
				select @premoderation = 1
			end
		end
	END

	DECLARE @ErrorCode int

	declare @forumid int
	
	INSERT INTO Forums (Title, keywords, SiteID, ForumStyle) VALUES(@subject, @keywords, @siteid, @forumstyle)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode
	
	SELECT @forumid = @@IDENTITY

	-- Add user to the forum for their own entry
	INSERT INTO FaveForums (UserID, ForumID) VALUES (@editor, @forumid)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode

	declare @curdate datetime
	SELECT @curdate = getdate()

	INSERT INTO GuideEntries (ExtraInfo,blobid,text, Editor, Subject, Keywords, ForumID, DateCreated, 
								Style, Status, Hidden, SiteID,Submittable, Type, PreProcessed,
								CanRead, CanWrite, CanChangePermissions)
		VALUES (@extrainfo,0,@bodytext, @editor, @subject, @keywords, @forumid, @curdate, @style, 
				@status, CASE WHEN @premoderation = 1 THEN 3 ELSE NULL END , @siteid,
				@submittable, @guidetypeid, @preprocessed, @canread, @canwrite, @canchangepermissions)
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode

	declare @guideentry int
	SELECT @guideentry = @@IDENTITY

	IF @researcher IS NOT NULL
		INSERT INTO Researchers (EntryID, UserID) VALUES (@guideentry, @researcher)

	declare @temp int, @checksum int
	SELECT @temp = @guideentry, @checksum = 0
	WHILE @temp > 0
	BEGIN
		SELECT @checksum = @checksum + (@temp % 10)
		SELECT @temp = @temp  / 10
	END
	SELECT @checksum = @checksum % 10
	SELECT @checksum = 9 - @checksum
	SELECT @checksum = @checksum + (10 * @guideentry)
	
	UPDATE GuideEntries SET h2g2ID = @checksum WHERE EntryID = @guideentry 
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode

	-- Make sure we Update the new entry in the ArticleDuplicates table!
	IF (@hash IS NOT NULL)
	BEGIN
		UPDATE ArticleDuplicates SET h2g2ID = @checksum, UserID = @editor, DateCreated = @curdate WHERE HashValue = @hash
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
			RETURN @ErrorCode
	END

	if (@groupnumber IS NOT NULL)
	BEGIN
		INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, CanRead, CanWrite) 
			SELECT @checksum, (SELECT OwnerTeam FROM Clubs WHERE ClubID = @groupnumber), 1, 1
		INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, CanRead, CanWrite) 
			SELECT @checksum, (SELECT MemberTeam FROM Clubs WHERE ClubID = @groupnumber), 1, 1
	END
	
	-- Lastly, make sure the editor is given edit permissions
	INSERT INTO GuideEntryPermissions(h2g2Id, TeamId, Priority, CanRead, CanWrite, CanChangePermissions) 
		SELECT @checksum, TeamID, 1, 1, 1, 1 FROM UserTeams WHERE UserId = @editor AND SiteID = @siteid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
		RETURN @ErrorCode
		
	-- update content signif. We don't want zeitgeist to fail this procedure so sp's error codes are not processed.
--	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'CreateGuideEntry',
--											  @siteid		= @siteid, 
--											  @entryid		= @guideentry, 
--											  @userid		= @editor

	DECLARE @ZeitgeistEvent uniqueidentifier
	DECLARE @Message nvarchar(2500)

	SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>CreateGuideEntry</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><ENTRYID>'+CAST(@guideentry as varchar(20))+'</ENTRYID><USERID>'+CAST(@editor as varchar(20))+'</USERID></ZEITGEISTEVENT>';

	BEGIN DIALOG CONVERSATION @ZeitgeistEvent
	  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
	  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
	  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
	  WITH ENCRYPTION = OFF;


	SEND ON CONVERSATION @ZeitgeistEvent
	  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CreateGuideEntry] (@Message)

	SELECT @returnentryid = @guideentry, @returndatecreated = @curdate, @returnforumid = @forumid, @returnh2g2id = @checksum, @returnhaveduplicate = 0
	return 0
END

-- ADDARTICLESTOHIERARCHY - check that addarticlestohierarchy has not changed since this was taken 2007-10-18
ALTER PROCEDURE addarticlestohierarchy @nodeid int, @h2g2ids VARCHAR(255), @userid int, @siteid INT
As

DECLARE @ErrorCode INT
DECLARE @Success INT
SET @success = 1
DECLARE @duplicate INT

DECLARE @entryid INT
DECLARE @h2g2id INT

BEGIN TRANSACTION

DECLARE entry_cursor CURSOR DYNAMIC FOR
SELECT entryid, h2g2id 
FROM GuideEntries g WITH (NOLOCK)
INNER JOIN udf_splitvarchar(@h2g2ids) u ON u.element = g.h2g2id AND g.siteid = @siteid

OPEN entry_cursor
FETCH NEXT FROM entry_cursor INTO @entryid, @h2g2id
WHILE ( @@FETCH_STATUS = 0 )
BEGIN
	SET @success = 1
	SET @duplicate = 0
	IF EXISTS ( SELECT entryid FROM HierarchyArticleMembers ha WHERE ha.NodeId = @nodeid AND ha.entryid = @entryid ) 
	BEGIN
		SET @success = 0
		SET @duplicate = 1
	END 

	IF @duplicate = 0
	BEGIN
		INSERT INTO hierarchyarticlemembers (NodeID,EntryID) 
		VALUES (@nodeid, @entryid)
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		UPDATE hierarchy SET ArticleMembers = ISNULL(ArticleMembers,0) + 1  WHERE nodeid=@nodeid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		UPDATE GuideEntries SET LastUpdated = getdate() WHERE EntryID = @entryid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		EXEC @ErrorCode = addtoeventqueueinternal 'ET_CATEGORYARTICLETAGGED', @nodeid, 'IT_NODE', @h2g2id, 'IT_H2G2', @userid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

--		EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc		= 'AddArticleToHierarchy',
--												  @siteid			= @siteid, 
--												  @nodeid			= @nodeid, 
--												  @entryid			= @entryid,
--												  @userid			= @userid

	DECLARE @ZeitgeistEvent uniqueidentifier
	DECLARE @Message nvarchar(2500)

	SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddArticleToHierarchy</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><ENTRYID>'+CAST(@entryid as varchar(20))+'</ENTRYID><USERID>'+CAST(@userid as varchar(20))+'</USERID><NODEID>'+CAST(@nodeid as varchar(20))+'</NODEID></ZEITGEISTEVENT>';

	BEGIN DIALOG CONVERSATION @ZeitgeistEvent
	  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
	  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
	  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
	  WITH ENCRYPTION = OFF;


		SEND ON CONVERSATION @ZeitgeistEvent
		  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddArticleToHierarchy] (@Message)

		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	END

	--Use multiple resultsets - one resultset for each article. 
	SELECT 'Success' = @success, 
		'ObjectName' = g.Subject,
		'Duplicate' = @duplicate,
		'h2g2Id' = g.h2g2id,
		( SELECT DisplayName FROM Hierarchy h WHERE h.NodeId = @nodeid) AS NodeName
	FROM GuideEntries g
	WHERE g.entryid = @entryid


	FETCH NEXT FROM entry_cursor INTO @entryid, @h2g2id
END

CLOSE entry_cursor
DEALLOCATE entry_cursor

COMMIT TRANSACTION
RETURN 0

HandleError:
ROLLBACK TRANSACTION
CLOSE entry_cursor
DEALLOCATE entry_cursor
SELECT 'Success' = 0
RETURN @ErrorCode

-- ADDARTICLETOHIERARCHY - Check this has no
CREATE PROCEDURE addarticletohierarchy @nodeid int, @h2g2id int, @userid int
As

DECLARE @Success INT
SET @Success = 1
DECLARE @Duplicate INT
SET @Duplicate = 0

DECLARE @EntryID int
SET @EntryID=@h2g2id/10

IF NOT EXISTS (SELECT * from hierarchyarticlemembers where nodeid=@nodeid AND EntryID=@EntryID)
BEGIN
	BEGIN TRANSACTION 

	DECLARE @ErrorCode 	INT

	-- Add article to hierarchy node
	INSERT INTO hierarchyarticlemembers (NodeID,EntryID) VALUES(@nodeid,@EntryID)
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	-- Update the ArticleMembers count
	UPDATE hierarchy SET ArticleMembers = ISNULL(ArticleMembers,0)+1 WHERE nodeid=@nodeid
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	
	-- Refresh the guide entry.  Forces the article cache to clear
	UPDATE GuideEntries SET LastUpdated = getdate() WHERE EntryID = @EntryID
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	COMMIT TRANSACTION

	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_CATEGORYARTICLETAGGED', @nodeid, 'IT_NODE', @h2g2id, 'IT_H2G2', @userid

	-- update ContentSignif. We don't want zeitgeist to fail this procedure. If it works, it works!	
	DECLARE @SiteID INT

	SELECT @SiteID = SiteID FROM dbo.GuideEntries WHERE EntryID = @EntryID

--	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc		= 'AddArticleToHierarchy',
--											  @siteid			= @SiteID, 
--											  @nodeid			= @nodeid, 
--											  @entryid			= @EntryID,
--											  @userid			= @userid

	DECLARE @ZeitgeistEvent uniqueidentifier
	DECLARE @Message nvarchar(2500)

	SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddArticleToHierarchy</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><ENTRYID>'+CAST(@entryid as varchar(20))+'</ENTRYID><USERID>'+CAST(@userid as varchar(20))+'</USERID><NODEID>'+CAST(@nodeid as varchar(20))+'</NODEID></ZEITGEISTEVENT>';

	BEGIN DIALOG CONVERSATION @ZeitgeistEvent
	  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
	  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
	  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
	  WITH ENCRYPTION = OFF;


		SEND ON CONVERSATION @ZeitgeistEvent
		  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CreateGuideEntry] (@Message)

		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	END
END
ELSE
BEGIN
	SET @Success = 0
	SET @Duplicate = 1
END

SELECT 'Success' = @Success,'Duplicate' = @Duplicate, 'ObjectName' = g.Subject, 'NodeName' = h.DisplayName 
			FROM GuideEntries g, Hierarchy h
			WHERE g.EntryID=@EntryID AND h.nodeid=@nodeid

RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode

-- ADDCLUBSTOHIERARCHY - check that addarticlestohierarchy has not changed since this was taken 2007-10-18
ALTER PROCEDURE addclubstohierarchy @nodeid int, @clubslist VARCHAR(255), @userid int, @siteid INT
AS

DECLARE @success INT
DECLARE @Duplicate INT
DECLARE @ErrorCode 	INT

BEGIN TRANSACTION 

DECLARE @clubid INT
DECLARE club_cursor CURSOR DYNAMIC FOR
SELECT clubid 
FROM Clubs c WITH (NOLOCK)
INNER JOIN udf_splitvarchar(@clubslist) u ON u.element = clubid
WHERE c.SiteId = @siteid

OPEN club_cursor
FETCH NEXT FROM club_cursor INTO @clubid
WHILE ( @@FETCH_STATUS = 0 )
BEGIN
	SET @duplicate = 0
	SET @success = 1
	IF EXISTS ( SELECT clubid FROM HierarchyClubMembers where clubid = @clubid and nodeid = @nodeid )
	BEGIN
		SET @duplicate = 1
		SET @success = 0
	END
	
	IF @duplicate = 0 
	BEGIN
		INSERT INTO hierarchyclubmembers (NodeID,ClubID) 
		VALUES (  @nodeid, @clubid )
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		UPDATE hierarchy SET ClubMembers = ISNULL(ClubMembers,0) + 1 WHERE nodeid=@nodeid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError


		-- Refresh the clubs guide entry.  Forces the article cache to clear
		UPDATE GuideEntries SET LastUpdated  = getdate()
		FROM Clubs c, GuideEntries g
		WHERE c.clubid = @clubid AND g.h2g2id = c.h2g2id
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
		EXEC @ErrorCode = addtoeventqueueinternal 'ET_CATEGORYCLUBTAGGED', @nodeid, 'IT_NODE', @clubid, 'IT_CLUB', @userid


		-- update ContentSignif. We don't want zeitgeist to fail this procedure. If it works, it works!
--		EXEC @ErrorCode = dbo.updatecontentsignif	@activitydesc	= 'AddClubToHierarchy',
--													@siteid		= @SiteID, 
--													@nodeID		= @nodeid, 
--													@clubid		= @clubid, 
--													@userid		= @userid

		DECLARE @ZeitgeistEvent uniqueidentifier
		DECLARE @Message nvarchar(2500)

		SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddClubToHierarchy</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><CLUBID>'+CAST(@clubid as varchar(20))+'</CLUBID><USERID>'+CAST(@userid as varchar(20))+'</USERID><NODEID>'+CAST(@nodeid as varchar(20))+'</NODEID></ZEITGEISTEVENT>';

		BEGIN DIALOG CONVERSATION @ZeitgeistEvent
		  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
		  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
		  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
		  WITH ENCRYPTION = OFF;


			SEND ON CONVERSATION @ZeitgeistEvent
			  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddClubToHierarchy] (@Message)

			SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
		END

	END

	--Return a resultset for each row updated.
	Select	'Success' = @Success, 
			'Duplicate' = @duplicate, 
			'ObjectName' = g.Subject, 
			'ClubId' = c.clubid,
			( SELECT DisplayName FROM Hierarchy h WHERE h.NodeId = @nodeid) AS NodeName
	FROM Clubs c 
	INNER JOIN GuideEntries g ON g.h2g2id = c.h2g2id
	WHERE c.clubid = @clubid
	
	FETCH NEXT FROM club_cursor INTO @clubid
END

COMMIT TRANSACTION

CLOSE club_cursor
DEALLOCATE club_cursor

RETURN 0

HandleError:
ROLLBACK TRANSACTION
CLOSE club_cursor
DEALLOCATE club_cursor
SELECT 'Success' = 0
RETURN @ErrorCode

-- ADDCLUBTOHIERARCHY - check that addarticlestohierarchy has not changed since this was taken 2007-10-18
ALTER PROCEDURE addclubtohierarchy @nodeid int, @clubid int, @userid int
AS

DECLARE @Success INT
SET @Success = 1
DECLARE @Duplicate INT
SET @Duplicate = 0

IF NOT EXISTS (SELECT * from hierarchyclubmembers where nodeid=@nodeid AND clubid=@clubid)
BEGIN
	BEGIN TRANSACTION 
	DECLARE @ErrorCode 	INT

	INSERT INTO hierarchyclubmembers (NodeID,ClubID) VALUES(@nodeid,@clubid)
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	UPDATE hierarchy SET ClubMembers = ISNULL(ClubMembers,0)+1 WHERE nodeid=@nodeid
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	declare @h2g2id int
	SELECT @h2g2id = h2g2id FROM Clubs WHERE ClubID = @clubid
		-- Refresh the guide entry.  Forces the article cache to clear
	UPDATE GuideEntries SET LastUpdated = getdate() WHERE h2g2ID = @h2g2id
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	COMMIT TRANSACTION

	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_CATEGORYCLUBTAGGED', @nodeid, 'IT_NODE', @clubid, 'IT_CLUB', @userid

	-- update ContentSignif. We don't want zeitgeist to fail this procedure. If it works, it works!
	DECLARE @SiteID INT

	SELECT @siteid = SiteID  FROM Clubs  WHERE clubid = @clubid

--	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'AddClubToHierarchy',
--											  @siteid		= @SiteID, 
--											  @nodeID		= @nodeid, 
--											  @clubid		= @clubid, 
--											  @userid		= @userid

	DECLARE @ZeitgeistEvent uniqueidentifier
	DECLARE @Message nvarchar(2500)

	SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddClubToHierarchy</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><CLUBID>'+CAST(@clubid as varchar(20))+'</CLUBID><USERID>'+CAST(@userid as varchar(20))+'</USERID><NODEID>'+CAST(@nodeid as varchar(20))+'</NODEID></ZEITGEISTEVENT>';

	BEGIN DIALOG CONVERSATION @ZeitgeistEvent
	  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
	  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
	  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
	  WITH ENCRYPTION = OFF;


		SEND ON CONVERSATION @ZeitgeistEvent
		  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddClubToHierarchy] (@Message)

		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
END
ELSE
BEGIN
	SET @Success = 0
	SET @Duplicate = 1
END

Select 'Success' = @Success, 'Duplicate' = @Duplicate, 'ObjectName' = g.Subject, 'NodeName' = h.DisplayName 
			FROM GuideEntries g
			INNER JOIN Clubs c ON c.ClubID = @clubid AND g.h2g2id=c.h2g2id
			INNER JOIN Hierarchy h ON h.NodeID = @nodeid

RETURN 0

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode


-- ADDRESPONSETOVOTE - check that addarticlestohierarchy has not changed since this was taken 2007-10-18
ALTER PROCEDURE addresponsetovote @ivoteid int, @iuserid int, @uid uniqueidentifier, @iresponse int, @bvisible TinyInt, @isiteid int, @ithreadid int = 0
AS
	BEGIN TRANSACTION
	
	DECLARE @ErrorCode 	INT
	DECLARE @ClubID 	INT
	
	INSERT INTO VoteMembers(VoteID,UserID,UID,Response,DateVoted,Visible) VALUES (@ivoteid,@iuserid,@uid,@iresponse,GetDate(),@bvisible)
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	IF (@ithreadid != 0)
	BEGIN
		insert into ForumLastUpdated (ForumID, LastUpdated)
			select t.ForumID, getdate() from Threads t where t.ThreadID = @ithreadid
/*
		UPDATE Forums SET LastUpdated = getdate() WHERE ForumID IN 
		(
			SELECT t.ForumID FROM Threads t
				INNER JOIN ThreadVotes v ON v.ThreadID = t.ThreadID
				WHERE v.VoteID = @ivoteid AND t.ThreadID = @ithreadid
		)
*/
		IF (@@ERROR <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END
	END

	COMMIT TRANSACTION

	IF(dbo.udf_getsiteoptionsetting(@isiteid, 'Zeitgeist', 'UseZeitgeist') = 1)
	BEGIN
		DECLARE @ContentAuthor	INT;
		DECLARE @VoteType		INT; 
		DECLARE @ThreadID		INT; 
		DECLARE @EntryID		INT; 

		SELECT @VoteType = Type
		  FROM dbo.Votes 
		 WHERE VoteID = @ivoteid;

		IF (@VoteType = 1)
		BEGIN
			-- Club vote
			SELECT @ContentAuthor = ge.Editor, 
				   @ClubID		  = cv.ClubID
			  FROM dbo.ClubVotes cv WITH (NOLOCK) 
					INNER JOIN dbo.Clubs c WITH (NOLOCK) ON cv.ClubID = c.ClubID
					INNER JOIN dbo.GuideEntries ge WITH (NOLOCK) ON c.h2g2ID = ge.h2g2ID
			 WHERE cv.VoteID = @ivoteid;
		END
		ELSE IF (@VoteType = 2)
		BEGIN
			SELECT @ContentAuthor = UserID, 
				   @ThreadID	  = tv.ThreadID
			  FROM dbo.ThreadVotes tv WITH (NOLOCK)
					INNER JOIN dbo.ThreadEntries te WITH (NOLOCK) ON tv.ThreadID = te.ThreadID AND PostIndex = 0 
			 WHERE tv.VoteID = @ivoteid;
		END
		ELSE IF (@VoteType = 3)
		BEGIN
			SELECT @ContentAuthor = ge.Editor, 
				   @EntryID = @entryID
			  FROM dbo.PageVotes pv
					INNER JOIN dbo.GuideEntries ge on pv.ItemID = ge.h2g2ID -- assumes that there is only one type of Vote (type = 1). Must change if votes on objects other than GuideEntries are implemented.
			 WHERE pv.VoteID = @ivoteid;
		END

		DECLARE @UserToIncrement INT; -- User to increment the zeitgeist score of. 

		IF (dbo.udf_getsiteoptionsetting(@isiteid, 'Zeitgeist', 'AddResponseToVote-IncrementAuthor') = 1)
		BEGIN
			SELECT @UserToIncrement = @ContentAuthor; 
		END
		ELSE
		BEGIN
			SELECT @UserToIncrement = @iuserid; 
		END

		DECLARE @ZeitgeistEvent uniqueidentifier
		DECLARE @Message nvarchar(2500)

		IF (@iresponse > 0)
		BEGIN
--			EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'AddPositiveResponseToVote',
--													  @siteid		= @isiteid,  
--													  @userid		= @UserToIncrement,
--													  @clubid		= @ClubID, 
--													  @entryid		= @EntryID, 
--													  @threadid		= @ThreadID

			SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddPositiveResponseToVote</DESCRIPTION><SITEID>'+CAST(@isiteid as varchar(20))+'</SITEID><ENTRYID>'+CAST(@EntryID as varchar(20))+'</ENTRYID><USERID>'+CAST(@UserToIncrement as varchar(20))+'</USERID><CLUBID>'+CAST(@ClubID as varchar(20))+'</CLUBID><THREADID>'+CAST(@ThreadID as varchar(20))+'</THREADID></ZEITGEISTEVENT>';

			BEGIN DIALOG CONVERSATION @ZeitgeistEvent
			  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
			  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
			  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
			  WITH ENCRYPTION = OFF;


				SEND ON CONVERSATION @ZeitgeistEvent
				  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddPositiveResponseToVote] (@Message)
			END
		END
		ELSE
		BEGIN
--			EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'AddNegativeResponseToVote',
--													  @siteid		= @isiteid,  
--													  @userid		= @UserToIncrement, 
--													  @clubid		= @ClubID, 
--													  @entryid		= @EntryID, 
--													  @threadid		= @ThreadID

			SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddNegativeResponseToVote</DESCRIPTION><SITEID>'+CAST(@isiteid as varchar(20))+'</SITEID><ENTRYID>'+CAST(@EntryID as varchar(20))+'</ENTRYID><USERID>'+CAST(@UserToIncrement as varchar(20))+'</USERID><CLUBID>'+CAST(@ClubID as varchar(20))+'</CLUBID><THREADID>'+CAST(@ThreadID as varchar(20))+'</THREADID></ZEITGEISTEVENT>';

			BEGIN DIALOG CONVERSATION @ZeitgeistEvent
			  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
			  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
			  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
			  WITH ENCRYPTION = OFF;


				SEND ON CONVERSATION @ZeitgeistEvent
				  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddPositiveResponseToVote] (@Message)
		END
	END	
	
	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_VOTEADDED', @ClubID, 'IT_CLUB', @iVoteID, 'IT_VOTE', @iuserid
	
RETURN 0

-- ADDTHREADSTOHIERARCHY - check that addthreadstohierarchy has not changed since this was taken 2007-11-12
/* Expects a comma separated list of threads to add to a hierarchy node */
ALTER PROCEDURE addthreadstohierarchy @nodeid INT, @threadlist VARCHAR(255), @userid INT,  @siteid INT
AS

DECLARE @Success INT
DECLARE @Duplicate INT
DECLARE @ErrorCode INT

BEGIN TRANSACTION

DECLARE @forumid INT
DECLARE @threadid iNT
DECLARE thread_cursor CURSOR DYNAMIC FOR
SELECT threadid
FROM Threads t WITH (NOLOCK)
INNER JOIN udf_splitvarchar(@threadlist) s ON s.element = t.threadid
INNER JOIN Forums f ON f.forumid = t.forumid and f.siteid = @siteid

OPEN thread_cursor
FETCH NEXT FROM thread_cursor INTO @threadid
WHILE ( @@FETCH_STATUS = 0 )
BEGIN
	SET @success = 1
	SET @duplicate = 0
	IF EXISTS ( SELECT threadid FROM HierarchyThreadMembers ht WHERE ht.NodeId = @nodeid AND ht.threadid = @threadid ) 
	BEGIN
		SET @success = 0
		SET @duplicate = 1
	END 

	IF @duplicate = 0
	BEGIN
		
		INSERT INTO dbo.hierarchythreadmembers(NodeID, ThreadId) VALUES( @nodeid, @threadid)
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		UPDATE hierarchy SET ThreadMembers = ISNULL(ThreadMembers,0)+1 WHERE nodeid=@nodeid
		SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

		--Invalidate thread cache.									  
		Update Threads SET LastUpdated = getdate() WHERE threadid = @threadid
		
		-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
		EXEC addtoeventqueueinternal 'ET_CATEGORYTHREADTAGGED', @nodeid, 'IT_NODE', @threadid, 'IT_THREAD', @userid

		SELECT @forumid = forumid FROM threads WHERE threadid = @threadid
		/*
		EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'AddNoticeBoardPostToHierarchy', 
												  @siteid 		= @siteid, 
												  @nodeid		= @nodeid, 
												  @userid		= @userid, 
												  @threadid		= @threadid, 
												  @forumid		= @forumid*/

		SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddThreadToHierarchy</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><USERID>'+CAST(@userid as varchar(20))+'</USERID><NODEID>'+CAST(@nodeid as varchar(20))+'</NODEID><THREADID>'+CAST(@threadid as varchar(20))+'</THREADID><FORUMID>'+CAST(@forumid as varchar(20))+'</FORUMID></ZEITGEISTEVENT>';

		BEGIN DIALOG CONVERSATION @ZeitgeistEvent
		  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
		  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
		  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
		  WITH ENCRYPTION = OFF;


			SEND ON CONVERSATION @ZeitgeistEvent
			  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddThreadToHierarchy] (@Message)
	END

	SELECT	'Success' = @Success,
			'Duplicate' = @Duplicate, 
			'ObjectName' = t.FirstSubject, 
			'ThreadId' = t.threadId,
			( SELECT DisplayName FROM Hierarchy h WHERE h.NodeId = @nodeid) AS NodeName 
			FROM [dbo].Threads t
			WHERE t.ThreadId = @threadId

	FETCH NEXT FROM thread_cursor INTO @threadid
END

COMMIT TRANSACTION

CLOSE thread_cursor
DEALLOCATE thread_cursor

RETURN 0

HandleError:
ROLLBACK TRANSACTION
CLOSE thread_cursor
DEALLOCATE thread_cursor
SELECT 'Success' = 0
RETURN @ErrorCode

-- ADDTHREADTOHIERARCHY - check that addthreadstohierarchy has not changed since this was taken 2007-11-12
ALTER PROCEDURE addthreadtohierarchy @nodeid INT, @threadid INT, @userid int
AS

DECLARE @Duplicate INT
SET @Duplicate = 0

DECLARE @Success INT
SET @Success = 1

DECLARE @ErrorCode INT


IF NOT EXISTS (SELECT * from dbo.hierarchythreadmembers where nodeid=@nodeid AND threadid=@threadid)
BEGIN
	BEGIN TRANSACTION
		
	INSERT INTO dbo.hierarchythreadmembers(NodeID, ThreadId) VALUES( @nodeid, @threadid)
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError

	UPDATE hierarchy SET ThreadMembers = ISNULL(ThreadMembers,0)+1 WHERE nodeid=@nodeid
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	
	COMMIT TRANSACTION
	
	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	EXEC addtoeventqueueinternal 'ET_CATEGORYTHREADTAGGED', @nodeid, 'IT_NODE', @threadid, 'IT_THREAD', @userid

	-- update content signif.We don't want zeitgeist to fail this procedure. If it works, it works!
	DECLARE @siteid int, @forumid int

	SELECT @siteid = f.SiteID, @forumid = t.ForumID FROM Threads t
			INNER JOIN Forums f ON f.ForumID = t.ForumID
			WHERE t.ThreadID = @threadid
	
--	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'AddNoticeBoardPostToHierarchy', 
--											  @siteid 		= @siteid, 
--											  @nodeid		= @nodeid, 
--											  @userid		= @userid, 
--											  @threadid		= @threadid, 
--											  @forumid		= @forumid
		

	SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>AddThreadToHierarchy</DESCRIPTION><SITEID>'+CAST(@siteid as varchar(20))+'</SITEID><USERID>'+CAST(@userid as varchar(20))+'</USERID><NODEID>'+CAST(@nodeid as varchar(20))+'</NODEID><THREADID>'+CAST(@threadid as varchar(20))+'</THREADID><FORUMID>'+CAST(@forumid as varchar(20))+'</FORUMID></ZEITGEISTEVENT>';

	BEGIN DIALOG CONVERSATION @ZeitgeistEvent
	  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
	  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
	  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
	  WITH ENCRYPTION = OFF;


		SEND ON CONVERSATION @ZeitgeistEvent
		  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_AddThreadToHierarchy] (@Message)

	--Invalidate thread cache.									  
	Update Threads SET LastUpdated = getdate() WHERE threadid = @threadid
	SELECT @ErrorCode = @@ERROR; IF (@ErrorCode <> 0) GOTO HandleError
	
END
ELSE
BEGIN
	SET @Success = 0
	SET @Duplicate = 1
END

Select 'Success' = @Success,'Duplicate' = @Duplicate, 'ObjectName' = t.FirstSubject, 'NodeName' = h.DisplayName 
			FROM [dbo].Threads t
			INNER JOIN Hierarchy h ON h.NodeID = @nodeid
			WHERE t.ThreadId = @threadId

return(0)

HandleError:
ROLLBACK TRANSACTION
SELECT 'Success' = 0
RETURN @ErrorCode

-- COMPLETECLUBACTION - check that completeclubaction has not changed since this was taken 2007-11-12
ALTER procedure completeclubaction @userid int, @actionid int, @actionresult int, @siteid int = NULL, @currentsiteid int = 0
as
	declare @ErrorCode int
	
	BEGIN TRANSACTION
	declare @clubid int, @actiontype int, @actionuser int
	
	SELECT @clubid = ClubID, @actiontype = ActionType, @actionuser = UserID 
		FROM ClubMemberActions WITH(UPDLOCK)
			WHERE ActionID = @actionid AND ActionResult = 0
	declare @actionname varchar(255)
	EXEC getclubactionname @actiontype, @actionname OUTPUT
	if (@clubid IS NULL)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0, 'Reason' = 'nosuchaction', 'ActionID' = @actionid, 'ActionName' = @actionname
		Return 1
	END

	-- Get some info from the club
	declare @clubforum int, @clubjournal int, @ownerteam int, @memberteam int, @ownerforum int, @memberforum int
	SELECT @clubforum = ClubForum, @clubjournal = Journal, @ownerteam = OwnerTeam, @memberteam = MemberTeam, @ownerforum = t1.ForumID, @memberforum = t2.ForumID
		FROM Clubs c INNER JOIN Teams t1 ON c.OwnerTeam = t1.TeamID
					INNER JOIN Teams t2 ON c.MemberTeam = t2.TeamID
			WHERE ClubID = @clubid
	if (@clubforum IS NULL)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0, 'Reason' = 'nosuchclub', 'ActionID' = @actionid, 'ActionName' = @actionname
		Return 1
	END


	declare @canautomember int, @canautoowner int ,
												@canbecomemember int ,
												@canbecomeowner int ,
												@canapprovemembers int ,
												@canapproveowners int ,
												@candemoteowners int , 
												@candemotemembers int,
												@canviewactions int,
												@canview int,
												@canedit int,
												@isteammember int ,
												@isowner int

	
	EXEC getclubpermissionsinternal @userid, @clubid, 
												@canautomember OUTPUT,
												@canautoowner OUTPUT,
												@canbecomemember OUTPUT,
												@canbecomeowner OUTPUT,
												@canapprovemembers OUTPUT,
												@canapproveowners OUTPUT,
												@candemoteowners OUTPUT, 
												@candemotemembers OUTPUT,
												@canviewactions OUTPUT,
												@canview OUTPUT,
												@canedit OUTPUT,
												@isteammember OUTPUT,
												@isowner OUTPUT

	-- Now complete the action
	-- see if the user has the right to complete this action
	declare @isallowed int
	select @isallowed = CASE 
							-- join as member
							WHEN @actiontype = 1 AND (@canautomember = 1 OR @canapprovemembers = 1) THEN 1
							-- join as owner
							WHEN @actiontype = 2 AND (@canautoowner = 1 OR @canapproveowners = 1) THEN 1
							-- invited as member
							WHEN @actiontype = 3 AND (@userid = @actionuser) THEN 1
							-- invited as owner
							WHEN @actiontype = 4 AND (@userid = @actionuser) THEN 1
							-- Owner resigns to member
							WHEN @actiontype = 5 AND (@userid = @actionuser) THEN 1
							-- owner resigns completely
							WHEN @actiontype = 6 AND (@userid = @actionuser) THEN 1
							-- member resigns completely
							WHEN @actiontype = 7 AND (@userid = @actionuser) THEN 1
							-- Owner demotes owner to member
							WHEN @actiontype = 8 AND (@candemoteowners = 1) THEN 1
							-- owner removes owner completely
							WHEN @actiontype = 9 AND (@candemoteowners = 1) THEN 1
							-- owner removes member completely
							WHEN @actiontype = 10 AND (@candemotemembers = 1) THEN 1
							ELSE 0 END
	-- force permissions here for BBCStaff and editors?
		declare @found int

	SELECT @found = (
		SELECT 'found'=1 FROM Users u WHERE u.userid = @userid and u.status =2
		UNION
		SELECT 'found'=1 FROM GroupMembers gm 
			INNER JOIN Groups g ON g.GroupID = gm.GroupID and g.name = 'Editor'
			WHERE gm.userid = @userid and gm.siteid = @siteid
	)

	if (@found = 1)
	BEGIN
		SELECT @canautomember		= 1
		SELECT @canautoowner		= 1
		SELECT @canbecomemember		= 1
		SELECT @canbecomeowner		= 1
		SELECT @canapprovemembers	= 1
		SELECT @canapproveowners	= 1
		SELECT @candemoteowners		= 1
		SELECT @candemotemembers	= 1
		SELECT @canviewactions		= 1
		SELECT @canview				= 1
		SELECT @canedit				= 1
		SELECT @isteammember		= 1
		SELECT @isowner				= 1

		SELECT @isallowed			= 1

	END


	if (@isallowed = 0)
	BEGIN
		ROLLBACK TRANSACTION
		SELECT 'Success' = 0, 'Reason' = 'notallowed', 'ActionID' = @actionid, 'ActionName' = @actionname
		Return 1
	END

	-- Now perform the action required.
	IF (@actiontype = 1)	-- Join as member
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- This user will now become a member of the club
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @memberteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@memberteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- Try to insert all the necessary fave forums - a unique index will kill those which don't work
			INSERT INTO FaveForums (ForumID, UserID)
				SELECT ForumID, @actionuser FROM Forums WHERE ForumID IN (@clubforum, @clubjournal, @memberforum)
			-- Ignore an error at this point - we expect them
		END
	END
	ELSE IF (@actiontype = 2)	-- Join as owner
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- This user will now become a member of the club
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @memberteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@memberteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- And an owner
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @ownerteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@ownerteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- Try to insert all the necessary fave forums - a unique index will kill those which don't work
			INSERT INTO FaveForums (ForumID, UserID)
				SELECT ForumID, @actionuser FROM Forums WHERE ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			-- Ignore an error at this point - we expect them
		END
	END
	ELSE IF (@actiontype = 3)	-- invited as member
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate()
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- This user will now become a member of the club
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @memberteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@memberteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- Try to insert all the necessary fave forums - a unique index will kill those which don't work
			INSERT INTO FaveForums (ForumID, UserID)
				SELECT ForumID, @actionuser FROM Forums WHERE ForumID IN (@clubforum, @clubjournal, @memberforum)
			-- Ignore an error at this point - we expect them
		END
	END
	ELSE IF (@actiontype = 4)	-- invited as owner
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate()
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- This user will now become a member of the club
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @memberteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@memberteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			IF NOT EXISTS (SELECT * from TeamMembers WHERE TeamID = @ownerteam AND UserID = @actionuser)
			BEGIN
				INSERT INTO TeamMembers (TeamID, UserID) VALUES (@ownerteam, @actionuser)
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantaddtoteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- Try to insert all the necessary fave forums - a unique index will kill those which don't work
			INSERT INTO FaveForums (ForumID, UserID)
				SELECT ForumID, @actionuser FROM Forums WHERE ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			-- Ignore an error at this point - we expect them
		END
	END
	ELSE IF (@actiontype = 5)	-- Owner resigns to member
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners team
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID = @ownerteam AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID = @ownerteam AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE IF (@actiontype = 6)	-- Owner resigns completely
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners and members team
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE IF (@actiontype = 7)	-- Member resigns completely
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners and members team (just in case!)
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE IF (@actiontype = 8)	-- Owner demotes owner to member
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners team
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID = @ownerteam AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID = @ownerteam AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE IF (@actiontype = 9)	-- Owner removes owner completely
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners and members team
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE IF (@actiontype = 10)	-- Owner removes member completely
	BEGIN
		UPDATE ClubMemberActions
			SET ActionResult = @actionresult, DateCompleted = getdate(), OwnerID = @userid
				WHERE ActionID = @actionid
		select @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Success' = 0, 'Reason' = 'cantupdate', 'ActionID' = @actionid, 'ActionName' = @actionname
			RETURN @ErrorCode
		END
		-- Do something more if the result = 1
		if (@actionresult = 1)
		BEGIN
			-- Remove this user from the owners and members team (just in case!)
			IF EXISTS (SELECT * from TeamMembers WITH(UPDLOCK) WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser)
			BEGIN
				DELETE FROM TeamMembers WHERE TeamID IN (@ownerteam, @memberteam) AND UserID = @actionuser
				select @ErrorCode = @@ERROR
				IF (@ErrorCode <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					SELECT 'Success' = 0, 'Reason' = 'cantdeletefromteam', 'ActionID' = @actionid, 'ActionName' = @actionname
					RETURN @ErrorCode
				END
			END
			-- delete all tracking of the club's forums
			DELETE FROM FaveForums
				WHERE UserID = @actionuser AND ForumID IN (@clubforum, @clubjournal, @memberforum, @ownerforum)
			select @ErrorCode = @@ERROR
			IF (@ErrorCode <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'cantdeletefaveforums', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN @ErrorCode
			END
		END
	END
	ELSE -- Don't know what this is
	BEGIN
				ROLLBACK TRANSACTION
				SELECT 'Success' = 0, 'Reason' = 'unknownaction', 'ActionID' = @actionid, 'ActionName' = @actionname
				RETURN 0
	END

	COMMIT TRANSACTION

	-- Update ContentSignif. We don't want zeitgeist to fail this procedure. If it works, it works!
	IF ((@actiontype IN (1, 2, 3, 4)) AND (@actionresult = 1))
	BEGIN
--		EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc		= 'UserJoinTeam',
--												  @siteid			= @currentsiteid, 
--												  @clubid			= @clubid	

		SET @Message = N'<ZEITGEISTEVENT><DESCRIPTION>UserJoinTeam</DESCRIPTION><SITEID>'+CAST(@currentsiteid as varchar(20))+'</SITEID><CLUBID>'+CAST(@clubid as varchar(20))+'</CLUBID></ZEITGEISTEVENT>';

		BEGIN DIALOG CONVERSATION @ZeitgeistEvent
		  FROM SERVICE [//bbc.co.uk/dna/SendZeitgeistEventService]
		  TO SERVICE '//bbc.co.uk/dna/ReceiveZeitgeistEventService'
		  ON CONTRACT [//bbc.co.uk/dna/ZeitgeistEventContract]
		  WITH ENCRYPTION = OFF;


		SEND ON CONVERSATION @ZeitgeistEvent
		  MESSAGE TYPE [//bbc.co.uk/dna/Zeitgeist_CompleteClubAction] (@Message)
	END

	-- Must have succeeded - return a result
	SELECT 'Success' = 1, 'Reason' = '',   'ActionName' = @actionname, a.*,
		'ClubName' = c.Name, 
		'ActionUserName' = u.Username, U.FIRSTNAMES as ActionFirstNames, U.LASTNAME as ActionLastName, U.AREA as ActionArea, U.STATUS as ActionStatus, U.TAXONOMYNODE as ActionTaxonomyNode, J.ForumID as ActionJournal, U.ACTIVE as ActionActive, P.SITESUFFIX as ActionSiteSuffix, P.TITLE as ActionTitle,
		'OwnerUserName' = u2.Username, U2.FIRSTNAMES as OwnerFirstNames, U2.LASTNAME as OwnerLastName, U2.AREA as OwnerArea, U2.STATUS as OwnerStatus, U2.TAXONOMYNODE as OwnerTaxonomyNode, J2.ForumID as OwnerJournal, U2.ACTIVE as OwnerActive, P2.SITESUFFIX as OwnerSiteSuffix, P2.TITLE as OwnerTitle
		FROM ClubMemberActions a 
			INNER JOIN Users u ON a.UserID = u.UserID
			LEFT JOIN Preferences p on p.UserID = u.UserID AND p.SiteID = @currentsiteid
			INNER JOIN Clubs c ON a.ClubID = c.ClubID 
			INNER JOIN Users u2 ON a.OwnerID = u2.UserID 
			LEFT JOIN Preferences p2 on p2.UserID = u2.UserID AND p2.SiteID = @currentsiteid
			INNER JOIN Journals J on J.UserID = u.UserID and J.SiteID = @currentsiteid
			INNER JOIN Journals J2 on J2.UserID = u2.UserID and J2.SiteID = @currentsiteid
		WHERE ActionID = @actionID

-- fall through...
ReturnWithoutError:
	-- Add Event, DON'T CHECK FOR ERRORS! We don't want the event queue to fail this procedure. If it works, it works!
	-- See if we need to put an event in the event queue.
	IF (@actiontype IN (2,5,6,8,9))
	BEGIN
		EXEC addtoeventqueueinternal 'ET_CLUBOWNERTEAMCHANGE', @clubid, 'IT_CLUB', @actionuser, 'IT_USER', @userid
	END
	ELSE IF (@actiontype IN (1,7,10))
	BEGIN
		EXEC addtoeventqueueinternal 'ET_CLUBMEMBERTEAMCHANGE', @clubid, 'IT_CLUB', @actionuser, 'IT_USER', @userid
	END
	
	RETURN 0

/**********************************************/
/************** END OF CALLING SPs	***********/
/**********************************************/

