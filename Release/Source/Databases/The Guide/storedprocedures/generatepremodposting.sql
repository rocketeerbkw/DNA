CREATE PROCEDURE generatepremodposting
	@siteid int,
	@userid int, 
	@forumid int, 
	@inreplyto int, 
	@threadid int, 
	@subject nvarchar(255), 
	@content nvarchar(max), 
	@poststyle int, 
	@hash uniqueidentifier, 
	@keywords varchar(255), 
	@nickname nvarchar(255), 
	@type varchar(30), 
	@eventdate datetime,
	@clubid int, 
	@allowevententries tinyint, 
	@nodeid int, 
	@ipaddress varchar(25),
	@bbcuid uniqueidentifier,
	@iscomment tinyint,
	@threadread int, 
	@threadwrite int,
	@modnotes varchar(255),
	@forcepremodpostingdate datetime,
	@riskmodthreadentryqueueid int
AS

IF (@@TRANCOUNT = 0)
BEGIN
	RAISERROR ('generatepremodposting cannot be called outside a transaction!!!',16,1)
	RETURN 50000
END

-- We are assuming that this is called within a TRY CATCH block, hence no explicit error handling

-- Create a ThreadMod Entry and get it's ModID
DECLARE @ModID INT
INSERT INTO ThreadMod (ForumID, ThreadID, PostID, Status, NewPost, SiteID, IsPreModPosting, Notes)
	VALUES (@forumid, @threadid, 0, 0, 1, @siteid, 1, @modnotes)
SELECT @ModID = SCOPE_IDENTITY()

-- Now insert the values into the PreModPostings tables
INSERT INTO dbo.PreModPostings (ModID, UserID, ForumID, ThreadID, InReplyTo, Subject, Body,
								PostStyle, Hash, Keywords, Nickname, Type, EventDate,
								ClubID, NodeID, IPAddress, ThreadRead, ThreadWrite, SiteID, AllowEventEntries, BBCUID, IsComment)
	VALUES (@ModID, @userid, @forumid, @threadid, @inreplyto, @subject, @content,
			@poststyle, @hash, @keywords, @nickname, @type, @eventdate,
			@clubid, @Nodeid, @ipaddress, @threadread, @threadwrite, @SiteID, @AllowEventEntries, @bbcuid, @IsComment)

IF @forcepremodpostingdate IS NOT NULL
BEGIN
	-- If we were given a date for the premod posting, set the date up
	-- This can occur during the processing of a riskmod post
	UPDATE dbo.PreModPostings SET DatePosted=@forcepremodpostingdate WHERE ModID=@ModID
END

IF @riskmodthreadentryqueueid IS NOT NULL
BEGIN
	UPDATE dbo.PreModPostings SET RiskModThreadEntryQueueId=@riskmodthreadentryqueueid WHERE ModID=@ModID
END

-- mark that the user has posted already so that we don't have to do it in the createpremodentry proc
EXEC updateuserlastposted @userid,@siteid
