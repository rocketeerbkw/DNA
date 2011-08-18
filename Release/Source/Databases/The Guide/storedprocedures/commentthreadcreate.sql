CREATE PROCEDURE commentthreadcreate @commentforumid NVARCHAR(255), @userid INT, @content NVARCHAR(MAX), @hash uniqueidentifier, 
	@forcemoderation tinyint = 0, @forcepremoderation tinyint = 0 , @ignoremoderation tinyint = 0, 
	@isnotable tinyint = 0, @ipaddress varchar(50) = null, @bbcuid uniqueidentifier = null,
	@poststyle int =1, @modnotes varchar(255) = NULL, 
	@profanityxml xml = NULL -- List of profanities to be added to the ModTermMapping table  
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
	
	-- Check to see if the forum has gone past it's closing date, bypass for ignored moderation.
	IF (@ignoremoderation = 0 AND @ForumCloseDate < GetDate())
	BEGIN
		return 2
	END
	
	--Check Forum Permissions.
	DECLARE @canread INT
	DECLARE @canwrite INT
	EXEC @returncode = getforumpermissions @userid, @forumid, @canread output, @canwrite output
	
	IF ( @canwrite = 0 AND @ignoremoderation = 0 )
	BEGIN
		return 3
		
	END

	--With this forum we create a new thread per rating post
	DECLARE @subject NVARCHAR(255)
	SET @subject = ''

-- Comment specific single thread option code	
--	SELECT @threadid = te.threadid, 
--			@inreplyto = te.entryid,
--			@subject = ISNULL(f.title,'')
--			FROM ThreadEntries te
--			INNER JOIN Forums f ON f.ForumId = te.ForumId
--			WHERE f.forumid = @forumid AND te.PostIndex = 0

	DECLARE @newpostid INT
	DECLARE @newthreadid INT
	DECLARE @ispremodposting INT
	DECLARE @ispremoderated INT
	DECLARE @IsComment TINYINT
	SELECT @IsComment = 1 -- User's do not want comments appearing on their MorePosts page. This flag controls if ThreadPostings is populated. != 0 equates to don't populate.
	DECLARE @IsThreadedComment TINYINT
	SELECT @IsThreadedComment = 1 -- This flag controls if a post is a threaded comment. MAJOR HACK
	EXEC @returncode = posttoforuminternal @userid, @forumid, NULL, NULL, @subject, @content, 
	@poststyle, @hash, NULL, NULL, @newthreadid OUTPUT, @newpostid OUTPUT, NULL, NULL, @forcemoderation, 
	@forcepremoderation, @ignoremoderation, 1, 0, @ipaddress, NULL, 0, @ispremodposting OUTPUT, 
	@ispremoderated OUTPUT, @bbcuid, @isnotable, @IsComment, @modnotes, @IsThreadedComment,
	/*@ignoreriskmoderation*/ 0, @profanityxml

DECLARE @threadcount int
SELECT @threadcount = ThreadPostCount FROM Threads th WITH(NOLOCK) 
	WHERE th.threadid = @newthreadid

	-- Find out if post was premoderated.
	--DECLARE @premoderation INT
	--DECLARE @unmoderated INT
	--EXEC @returncode =  getmodstatusforforum @userid,@threadid,@forumid,@siteid,@premoderation OUTPUT,@unmoderated OUTPUT
	--IF @ignoremoderation = 1
	--BEGIN
	--	SET @premoderation = 0 
	--END
	
	SELECT 'ThreadID' = @newthreadid, 'PostID' = @newpostid, 'WasQueued' = 0, 'IsPreModPosting' = @ispremodposting, 'IsPreModerated' = @ispremoderated, 'ThreadPostCount' = @threadcount

	RETURN @ReturnCode
    
END
