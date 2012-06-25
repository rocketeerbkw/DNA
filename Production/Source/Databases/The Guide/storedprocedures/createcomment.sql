CREATE PROCEDURE createcomment @uniqueid VARCHAR(255), @userid INT, @siteid INT, @content NVARCHAR(MAX), @hash uniqueidentifier, @forcemoderation tinyint = 0, @forcepremoderation tinyint = 0 , @ignoremoderation tinyint = 0, @isnotable tinyint = 0, @poststyle tinyint, @ipaddress varchar(50) = null, @bbcuid uniqueidentifier = null
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
	
	SELECT @forumid = forumid, @contentsiteid = siteid, @hostpageurl = Url, @ForumCloseDate = ForumCloseDate FROM CommentForums WHERE UID = @uniqueid
	IF @forumid IS NULL
	BEGIN
		-- Error,  forum not found for this uniqueid.
		SELECT 'Forum not found' 'Error'
		RETURN 0
	END
	
	IF @siteid != @contentsiteid
	BEGIN
		-- Content relates to a different site .
		SELECT 0 'postid', @hostpageurl 'hostpageurl', 1 'canread', 0 'canwrite', 0 'ispremoderated', 0 'premodpostingmodid', @contentsiteid 'contentsiteid'
		RETURN 0
	END
	
	-- Check to see if the forum has gone past it's closing date, bypass for ignored moderation.
	IF (@ignoremoderation = 0 AND @ForumCloseDate < GetDate())
	BEGIN
		SELECT 0 'postid', @hostpageurl 'hostpageurl', 1 'canread', 0 'canwrite', 0 'ispremoderated', 0 'premodpostingmodid',  @contentsiteid 'contentsiteid'
		RETURN 0
	END
	
	--Check Forum Permissions.
	DECLARE @canread INT
	DECLARE @canwrite INT
	EXEC @returncode = getforumpermissions @userid, @forumid, @canread output, @canwrite output
	
	IF ( @canwrite = 0 AND @ignoremoderation = 0 )
	BEGIN
		SELECT 0 'postid', @hostpageurl 'hostpageurl', @canread 'CanRead', @canwrite 'CanWrite', 0 'ispremoderated', 0 'premodpostingmodid',  @contentsiteid 'contentsiteid'
		RETURN @returncode
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
	EXEC @returncode = posttoforuminternal  @userid, @forumid, @inreplyto, @threadid, @subject, @content, @poststyle, @hash, NULL, NULL, @newthreadid OUTPUT, 
											@newpostid OUTPUT, NULL, NULL, @forcemoderation, @forcepremoderation, @ignoremoderation, 1, 0, @ipaddress, NULL, 0, 
											@premodpostingmodid OUTPUT, @ispremoderated OUTPUT, @bbcuid, @isnotable, @IsComment,
											/*@modnotes*/ NULL,/*@isthreadedcomment*/ 0,/*@ignoreriskmoderation*/ 0

	-- Find out if post was premoderated.
	--DECLARE @premoderation INT
	--DECLARE @unmoderated INT
	--EXEC @returncode =  getmodstatusforforum @userid,@threadid,@forumid,@siteid,@premoderation OUTPUT,@unmoderated OUTPUT
	--IF @ignoremoderation = 1
	--BEGIN
	--	SET @premoderation = 0 
	--END
	SELECT ISNULL(@newpostid, 0) 'postid', @hostpageurl 'hostpageurl', ISNULL(@canread,1) 'canread', ISNULL(@canwrite,1) 'canwrite', ISNULL(@ispremoderated,0) 'ispremoderated', ISNULL(@premodpostingmodid,0) 'premodpostingmodid',  @contentsiteid 'contentsiteid'

	RETURN @returncode
    
END