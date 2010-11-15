CREATE PROCEDURE riskmod_postriskmodthreadentrytoforum @riskmodthreadentryqueueid int, @forcepremodposting bit, @newmodnotes varchar(255) = NULL
AS

/*
	IMPORTANT!!!
	This Stored procedure should never be called directly as it doesn't do any TRANSACTION calls!
	Make sure the calling procedure calls this within BEGIN / COMMIT TRANSACTION calls
*/
IF (@@TRANCOUNT = 0)
BEGIN
	RAISERROR ('riskmod_postriskmodthreadentrytoforum cannot be called outside a transaction!!!',16,1)
	RETURN 50000
END

-- IMPORTANT: It's assumed that the caller will call this within a BEGIN TRY/END TRY block to catch any errors that might be thrown

declare @userid int, @forumid int, @inreplyto int, @threadid int, @subject nvarchar(255), @content nvarchar(max), @dateposted datetime,@poststyle int, 
		@hash uniqueidentifier, @keywords varchar(255), @nickname nvarchar(255), @type varchar(30), @eventdate datetime, @forcemoderate tinyint,	
		@forcepremoderation tinyint, @ignoremoderation tinyint, @allowevententries tinyint, @clubid int, @nodeid int, @queueid int,
		@ipaddress varchar(25), @keyphrases varchar(5000), @allowqueuing tinyint, @bbcuid uniqueidentifier, @isnotable tinyint, 
		@iscomment tinyint, @modnotes varchar(255), @isthreadedcomment tinyint


SELECT  @userid = UserID, @forumid = ForumID, @inreplyto = InReplyTo, @threadid = ThreadID, @subject = Subject, @content = [Text], @dateposted = DatePosted, @poststyle = PostStyle, 
		@hash = [Hash], @keywords = KeyWords, @nickname = UserName, @type = Type, @eventdate = EventDate, @forcemoderate = 0,	
		@forcepremoderation = 0, @ignoremoderation = 0, @allowevententries  = AllowEventEntries, @clubid = ClubId, @nodeid = NodeId, @queueid = QueueId,
		@ipaddress = IPAddress, @bbcuid = BBCUID, @isnotable = IsNotable, 
		@iscomment = IsComment, @modnotes = ModNotes, @isthreadedcomment = IsThreadedComment
		FROM dbo.RiskModThreadEntryQueue
		WHERE RiskModThreadEntryQueueId = @riskmodthreadentryqueueid

IF @newmodnotes IS NOT NULL
BEGIN
	-- The caller wants to override the stored mod notes
	IF @modnotes IS NOT NULL AND LEN(@modnotes) > 0
		SET @modnotes = @newmodnotes + CHAR(13) + CHAR(10) + 'Old Notes: '+@modnotes
	ELSE
		SET @modnotes = @newmodnotes
END

declare @returnthreadid int, @ispremodposting int, @ispremoderated int, @newthreadentryid int
SET @ispremodposting = 0
DECLARE @ReturnCode INT 

-- Post the entry, ignoring risk moderation (otherwise we could be in an infinite loop!)
EXEC @ReturnCode = posttoforuminternal  @userid, @forumid, @inreplyto, @threadid, @subject, @content, @poststyle, @hash, @keywords, @nickname, @returnthreadid OUTPUT, 
										@newthreadentryid OUTPUT, @type, @eventdate, @forcemoderate, @forcepremoderation, @ignoremoderation, /*@AllowEventEntries*/DEFAULT, 
										@nodeid, @ipaddress, /*@queueid*/NULL, @clubid, @ispremodposting OUTPUT, @ispremoderated OUTPUT, @bbcuid, @isnotable, 
										@IsComment, @modnotes, @isthreadedcomment, /*@ignoreriskmoderation*/ 1, @forcepremodposting, /* @forcepremodpostingdate*/ @dateposted,
										@riskmodthreadentryqueueid

IF @ReturnCode = 0
BEGIN
	IF @newthreadentryid > 0
	BEGIN
		-- Make sure the DatePosted date is the date recorded at the point the post was received, as opposed to the date the post was processed.
		UPDATE dbo.ThreadEntries SET DatePosted = @dateposted
			WHERE EntryId = @newthreadentryid

		-- Update RiskModThreadEntryQueue with thread entry details, now that we have a thread entry
		UPDATE dbo.RiskModThreadEntryQueue 
			SET ThreadEntryId = te.EntryId, ThreadId = te.ThreadId
			FROM ThreadEntries te
			WHERE te.EntryId = @newthreadentryid
	END

	--Update Clubs Last Updated if new post to clubs forum.
	IF ( @clubid <> 0 AND ( @inreplyto Is NULL OR @inreplyto = 0 ) )
	BEGIN
		EXEC @ReturnCode = forceupdateentry 0, @clubid
	END
END

SELECT 'ThreadID' = @returnthreadid, 'PostID' = @newthreadentryid, 'WasQueued' = 0, 'IsPreModPosting' = @ispremodposting, 'IsPreModerated' = @ispremoderated

RETURN @ReturnCode
