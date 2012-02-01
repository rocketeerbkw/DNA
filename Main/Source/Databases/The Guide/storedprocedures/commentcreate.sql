CREATE PROCEDURE commentcreate @commentforumid VARCHAR(255), @userid INT, @content NVARCHAR(MAX), @hash uniqueidentifier, 
	@forcemoderation tinyint = 0, @forcepremoderation tinyint = 0 , @ignoremoderation tinyint = 0, 
	@isnotable tinyint = 0, @ipaddress varchar(50) = null, @bbcuid uniqueidentifier = null,
	@poststyle int =1, @modnotes varchar(255) = NULL, @nickname nvarchar(255) = NULL, 
	@profanityxml xml = NULL,  -- List of profanity ids to be added to the ModTermMapping table
	@applyprocesspremodexpirytime bit=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	 SET NOCOUNT ON;

	DECLARE @returncode INT
	DECLARE @forumid INT
	DECLARE @contentsiteid INT
	DECLARE @hostpageurl VARCHAR(255)
	DECLARE @ForumCloseDate DATETIME
	
	SELECT @forumid = forumid, @contentsiteid = siteid, @hostpageurl = Url, @ForumCloseDate = ForumCloseDate 
	FROM CommentForums WHERE UID = @commentforumid
	IF @forumid IS NULL
	BEGIN
		-- Error,  forum not found for this uniqueid.
		return 1
	END
	
	-- Check to see if the forum has gone past it's closing date, bypass for ignored moderation and for notable users.
	IF (@ignoremoderation = 0 AND @ForumCloseDate < GetDate() AND @isnotable = 0)
	BEGIN
		return 2
	END
	
	--Check Forum Permissions.
	DECLARE @canread INT
	DECLARE @canwrite INT
	EXEC @returncode = getforumpermissions @userid, @forumid, @canread output, @canwrite output
	
	IF ( @canwrite = 0 AND @ignoremoderation = 0 AND @isnotable = 0) --bypass for notable users
	BEGIN
		return 3
		
	END

	--This forum should have only one thread
	DECLARE @threadid INT 
	DECLARE @inreplyto INT
	DECLARE @subject NVARCHAR(255)
	SET @subject = ''
	SELECT @threadid = te.threadid, 
			@inreplyto = te.entryid,
			@subject = ISNULL(f.title,'')
			FROM ThreadEntries te
			INNER JOIN Forums f ON f.ForumId = te.ForumId
			WHERE f.forumid = @forumid AND te.PostIndex = 0

	DECLARE @newpostid INT
	DECLARE @newthreadid INT
	DECLARE @premodpostingmodid INT
	DECLARE @ispremoderated INT
	DECLARE @IsComment TINYINT
	SELECT @IsComment = 1 -- User's do not want comments appearing on their MorePosts page. This flag controls if ThreadPostings is populated. != 0 equates to don't populate.
	EXEC @returncode = posttoforuminternal @userid, @forumid, @inreplyto, @threadid, @subject, @content, 
	@poststyle, @hash, NULL, @nickname, @newthreadid OUTPUT, @newpostid OUTPUT, NULL, NULL, @forcemoderation, 
	@forcepremoderation, @ignoremoderation, 1, 0, @ipaddress, NULL, 0, @premodpostingmodid OUTPUT, 
	@ispremoderated OUTPUT, @bbcuid, @isnotable, @IsComment,
	@modnotes,/*@isthreadedcomment*/ 0,/*@ignoreriskmoderation*/ 0,
	@profanityxml, /*@forcepremodposting*/ 0,/*@forcepremodpostingdate*/ NULL,/*@riskmodthreadentryqueueid*/NULL,
	@applyprocesspremodexpirytime

	

	-- Find out if post was premoderated.
	--DECLARE @premoderation INT
	--DECLARE @unmoderated INT
	--EXEC @returncode =  getmodstatusforforum @userid,@threadid,@forumid,@siteid,@premoderation OUTPUT,@unmoderated OUTPUT
	--IF @ignoremoderation = 1
	--BEGIN
	--	SET @premoderation = 0 
	--END
	
	SELECT 'ThreadID' = @newthreadid, 'PostID' = @newpostid, 'WasQueued' = 0, 'PreModPostingModId' = @premodpostingmodid, 'IsPreModerated' = @ispremoderated

	RETURN @ReturnCode
    
END
