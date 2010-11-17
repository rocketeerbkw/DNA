/* posttoforuminternal
In: @userid - id of user posting
@forumid - id of forum
@inreplyto - NULL or id of posting they're replying to
@threadid - NULL or id of thread (we could get this from @inreplyto but this saves on queries
@content - textof the posting
@keywords - keywords for categorisation (may be NULL)
@forcemoderate - if 1, forces post into mod queue. Used when failing profanity check
@ignoremoderation tinyint = 0, 
@allowevententries tinyint = 1, 
@nodeid int = 0, 
@ipaddress varchar(25) = null,
@queueid int  = NULL, 
@clubid int = 0, 
@ispremodposting int OUTPUT, 
@bbcuid uniqueidentifier = NULL,
@isnotable tinyint = 0, 
@IsComment tinyint = 0 -- Flag to control if ThreadPostings is populated. != 0 equates to don't populate.
*/
CREATE PROCEDURE posttoforuminternal @userid int, 
										@forumid int, 
										@inreplyto int, 
										@threadid int, 
										@subject nvarchar(255), 
										@content nvarchar(max), 
										@poststyle int, 
										@hash uniqueidentifier, 
										@keywords varchar(255), 
										@nickname nvarchar(255) = NULL, 
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
										@iscomment tinyint = 0,
										@modnotes VARCHAR(255) = NULL,
										@isthreadedcomment tinyint = 0,
										@ignoreriskmoderation bit = 0,
										@forcepremodposting bit = 0,
										@forcepremodpostingdate datetime = NULL,
										@riskmodthreadentryqueueid int = NULL

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

-- First see if we have a duplicate post.  If we do, just return
IF EXISTS (SELECT * FROM PostDuplicates WHERE HashValue = @hash AND UserId=@userid AND ForumId=@forumid)
BEGIN
	SELECT @returnthread = ThreadID, @returnpost = PostID FROM PostDuplicates WHERE HashValue = @hash AND UserId=@userid AND ForumId=@forumid
	RETURN 0
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


-- Create PostDuplicate entry
-- later we have to update it with the actual values (like ThreadID etc.)
INSERT INTO PostDuplicates (HashValue, DatePosted, ForumID, ThreadID, Parent, UserID)
	VALUES(@hash, @curtime, @forumid, @threadid, @inreplyto, @userid)

/*
	Check to see if the site has the process premod messages set. This basically means that the post will not
	be inserted into the threads table untill it has passed moderation.
*/
IF (@forcepremodposting=1 OR (@premoderation = 1 AND dbo.udf_getsiteoptionsetting (@siteid,'Moderation','ProcessPreMod') = '1') )
BEGIN

	BEGIN TRY
		EXEC generatepremodposting		@siteid, @userid, @forumid, @inreplyto, @threadid, @subject, 
										@content, @poststyle, @hash, @keywords, @nickname, @type, 
										@eventdate, @clubid, @allowevententries, @nodeid, @ipaddress,
										@bbcuid, @iscomment, @threadread, @threadwrite, @modnotes, @forcepremodpostingdate,
										@riskmodthreadentryqueueid
										
		-- COMMIT and Now Set the IsPreModPosting flag and return
		COMMIT TRANSACTION
		SET @ispremodposting = 1
		RETURN 0
	    
	END TRY
	BEGIN CATCH
		SET @ErrorCode=ERROR_NUMBER()
		GOTO RollbackAndReturnErrorCode
	END CATCH
END

/*
	Deal with risk moderation
*/
DECLARE @riskModQueueId int

IF (@ignoremoderation = 0 AND @ignoreriskmoderation = 0 AND @unmoderated = 1 AND @premoderation = 0)  
BEGIN
	-- We are at this point because:
	--	The post is unmoderated
	--	AND we are not ignoring moderation all together, e.g. because it's an editor posting
	--	AND we are not ignoring risk moderation, e.g. because it's part of a publish after a risk mod assessment
	DECLARE @ison bit, @publishmethod char(1)
	EXEC riskmod_getsitestate @siteid ,@ison OUTPUT, @publishmethod OUTPUT
	IF (@ison = 1) -- Is Risk Moderation turned on for this post?
	BEGIN
		BEGIN TRY
			-- Record all the post details for risk assessment
			INSERT RiskModThreadEntryQueue (ThreadEntryId, PublishMethod, SiteId, ForumID, ThreadID, UserID, UserName, InReplyTo, Subject,  [Text], DatePosted, PostStyle,[Hash],IPAddress, BBCUID, KeyWords, Type, EventDate, AllowEventEntries, NodeId, QueueId, ClubId, IsNotable, IsComment, ModNotes, IsThreadedComment)
									VALUES (NULL,         @publishmethod,@siteid,@forumid,@threadid,@userid,@nickname,@inreplyto,@subject,@content,@curtime,   @poststyle,@hash,@ipaddress,@BBCUID,@keywords,@type,@eventdate,@allowevententries,@nodeid,@queueid,@clubid,@isnotable,@iscomment,@modnotes,@isthreadedcomment)
			SET @riskModQueueId = SCOPE_IDENTITY()
			
			-- Record the event for the BI Event processor
			EXEC addtoeventqueueinternal 'ET_POSTNEEDSRISKASSESSMENT', @riskModQueueId, 'IT_RISKMODQUEUEID', 0, 'IT_ALL', @userid
		
			IF @publishmethod = 'A' -- Publish after risk assessment
			BEGIN
				-- When publishing the post after risk moderation, we return at this point
				
				-- We need to delete the PostDuplicates entry, otherwise we won't be allowed to publish it for real later
				DELETE FROM PostDuplicates WHERE HashValue = @hash AND UserId=@userid AND ForumId=@forumid

				-- Let the caller know that the post has been queued like a premoderated post
				SET @ispremoderated = 1
				COMMIT TRANSACTION
				RETURN 0
			END
		END TRY
		BEGIN CATCH
			SET @ErrorCode=ERROR_NUMBER()
			GOTO RollbackAndReturnErrorCode
		END CATCH
	END
END


if (@inreplyto IS NULL AND @isthreadedcomment = 0)
BEGIN
    declare @forumstyle int
    select @forumstyle = ForumStyle from dbo.Forums WITH(NOLOCK) where ForumID = @forumid
    IF (@iscomment = 1 OR @forumstyle = 1)
    BEGIN
        -- check to see if there's already a thread in this forum
	    SELECT @threadid = te.threadid, 
			@inreplyto = te.entryid,
			@subject = ISNULL(f.title,'')
			FROM ThreadEntries te
			INNER JOIN Forums f ON f.ForumId = te.ForumId
			WHERE f.forumid = @forumid AND te.PostIndex = 0
	END
END

IF (@inreplyto IS NULL)
BEGIN
	/* We're starting a new thread */
	INSERT INTO Threads (ForumID, keywords, FirstSubject, VisibleTo, CanRead, CanWrite, Type, EventDate, LastPosted, LastUpdated) 
		SELECT @forumid, @keywords, 
				CASE WHEN @premoderation = 1 THEN '' ELSE @subject END, 
				NULL,
				ThreadCanRead, ThreadCanWrite, @type, @eventdate, @curtime, @curtime
				FROM Forums WITH(NOLOCK) WHERE ForumID = @forumid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		GOTO RollbackAndReturnErrorCode
	END
	SELECT @threadid = SCOPE_IDENTITY()
	-- Insert any necessary extra permissions
	INSERT INTO ThreadPermissions (ThreadID, TeamID, CanRead, CanWrite, Priority)
	SELECT @threadid, TeamID, CanRead, CanWrite, Priority FROM ForumPermissions
		WHERE ForumID = @forumid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		GOTO RollbackAndReturnErrorCode
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
				GOTO RollbackAndReturnErrorCode
			END

		END
	END

END


UPDATE Threads SET LastPosted = @curtime, LastUpdated = @curtime 
	WHERE ThreadID = @threadid
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	GOTO RollbackAndReturnErrorCode
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
		GOTO RollbackAndReturnErrorCode
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
	GOTO RollbackAndReturnErrorCode
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
		GOTO RollbackAndReturnErrorCode
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
		GOTO RollbackAndReturnErrorCode
	END
END

declare @entryid int
SELECT @entryid = SCOPE_IDENTITY()

--increment the post by thread counter for the specific thread
EXEC updatethreadpostcount @threadid, 1
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	GOTO RollbackAndReturnErrorCode
END

--Increment relevent ForumPostCount by 1
EXEC updateforumpostcount @forumid, NULL, 1
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	GOTO RollbackAndReturnErrorCode
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
			GOTO RollbackAndReturnErrorCode
		END

		UPDATE ThreadEntries SET FirstChild = @entryid WHERE EntryID = @inreplyto
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			GOTO RollbackAndReturnErrorCode
		END
	END
	ELSE
	BEGIN
		/* Add post as last sibling */
		UPDATE ThreadEntries SET PrevSibling = @lastreply, Parent = @inreplyto WHERE EntryID = @entryid
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			GOTO RollbackAndReturnErrorCode
		END

		UPDATE ThreadEntries SET NextSibling = @entryid WHERE EntryID = @lastreply
		SELECT @ErrorCode = @@ERROR
		IF (@ErrorCode <> 0)
		BEGIN
			GOTO RollbackAndReturnErrorCode
		END
	END
END

-- Update Forum LastUpdated avoiding hotspots in Forum table.
INSERT INTO ForumLastUpdated (ForumID, LastUpdated) VALUES(@forumid, @curtime)
SELECT @ErrorCode = @@ERROR
IF (@ErrorCode <> 0)
BEGIN
	GOTO RollbackAndReturnErrorCode
END

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
		GOTO RollbackAndReturnErrorCode
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
		GOTO RollbackAndReturnErrorCode
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
			GOTO RollbackAndReturnErrorCode
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
		GOTO RollbackAndReturnErrorCode
	END

	UPDATE ThreadPostings
		SET LastUserPosting = @curtime, Replies = 0, LastUserPostID = @entryid
			WHERE ThreadID = @threadid AND UserID = @userid
	SELECT @ErrorCode = @@ERROR
	IF (@ErrorCode <> 0)
	BEGIN
		GOTO RollbackAndReturnErrorCode
	END

*/

IF (@unmoderated = 0)
BEGIN
	BEGIN TRY
		EXEC QueueThreadEntryForModeration @forumid, @threadid, @entryid, @siteid, @modnotes
	END TRY
	BEGIN CATCH
		SET @ErrorCode = ERROR_NUMBER()
		GOTO RollbackAndReturnErrorCode
	END CATCH
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
			GOTO RollbackAndReturnErrorCode
		END
	END

*/

-- update the previously posted PostDuplicates table entry
UPDATE PostDuplicates SET ThreadID = @threadid, PostID = @entryid WHERE HashValue = @hash AND UserId=@userid AND ForumId = @forumid

-- Add an entry to the queue to allow the processor to work
INSERT INTO ThreadPostingsQueue (EntryID) VALUES(@entryid)

IF @riskModQueueId IS NOT NULL
BEGIN
	-- Hook up the risk mod record with the actual thread and thread entry that was created
	UPDATE RiskModThreadEntryQueue SET ThreadId=@threadid, ThreadEntryId=@entryid WHERE RiskModThreadEntryQueueId = @riskModQueueId
END

COMMIT TRANSACTION

-- Update Forum LastPosted outside transaction to avoid potential hospots on Forums table. Don't fail on error.
UPDATE Forums SET LastPosted = @curtime WHERE ForumID = @forumid

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
		EXEC addtoeventqueueinternal 'ET_POSTTOFORUM', @forumid, 'IT_FORUM', @entryid, 'IT_ENTRYID', @userid
	END
	ELSE
	BEGIN
		-- Thread has reply
		EXEC addtoeventqueueinternal 'ET_POSTREPLIEDTO', @threadid, 'IT_THREAD', @inreplyto, 'IT_POST', @userid
		EXEC addtoeventqueueinternal 'ET_POSTTOFORUM', @forumid, 'IT_FORUM', @entryid, 'IT_ENTRYID', @userid
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

	EXEC @ErrorCode = dbo.updatecontentsignif @activitydesc	= 'PostToForum',
											  @siteid		= @siteid, 
											  @nodeid		= @nodeid, 
											  @entryid		= @GuideEntry_EntryID, 
											  @userid		= @userid, 
											  @threadid		= @threadid, 
											  @forumid		= @forumid, 
											  @clubid		= @clubid

END

-- Auto Close Thread if post limit reached.
DECLARE @postlimit INT
DECLARE @threadpostcount INT
SELECT @postlimit = CAST(ISNULL(dbo.udf_getsiteoptionsetting(@siteid, 'Forum', 'PostLimit' ),'0') AS INT )
IF ( @postlimit > 0 )
BEGIN
    SELECT @threadpostcount = ThreadPostCount FROM Threads WHERE ThreadId = @threadid
    IF ( @threadpostcount >= @postlimit )
    BEGIN
        -- Do not apply autoclose if threads forum is associated with an editors article.
        IF ( NOT EXISTS(SELECT * FROM GuideEntries g
                        INNER JOIN GroupMembers gm ON gm.userid = g.editor AND gm.siteid = @siteid
                        INNER JOIN Groups gr ON gr.groupid = gm.groupid AND gr.name='editor'
                        WHERE g.forumid = @forumid  ) )
        BEGIN
            UPDATE Threads SET CanWrite = 0 WHERE ThreadId = @threadid 
        END
    END
END 

SELECT @returnthread = @threadid, @returnpost = @entryid

RETURN 0

RollbackAndReturnErrorCode:
	ROLLBACK TRANSACTION
	EXEC Error @ErrorCode
	RETURN @ErrorCode
