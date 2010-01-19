/* posttoforum
In: @userid - id of user posting
@forumid - id of forum
@inreplyto - NULL or id of posting they're replying to
@threadid - NULL or id of thread (we could get this from @inreplyto but this saves on queries
@content - textof the posting
@keywords - keywords for categorisation (may be NULL)
@forcemoderate - set if a profanity is found
@ignoremoderation - set for a superuser/editor.
*/
CREATE PROCEDURE posttoforum @userid int, 
							@forumid int, 
							@inreplyto int, 
							@threadid int, 
							@subject nvarchar(255), 
							@content nvarchar(max), 
							@poststyle int, 
							@hash uniqueidentifier, 
							@keywords varchar(255) = NULL, 
							@nickname nvarchar(255) = NULL, 
							@type varchar(30) = NULL, 
							@eventdate datetime = NULL, 
							@forcemoderate tinyint = 0,	
							@forcepremoderation tinyint = 0,	
							@ignoremoderation tinyint = 0,	
							@clubid int = 0, 
							@nodeid int = 0,
							@ipaddress varchar(25) = null,
							@keyphrases varchar(5000) = NULL,
							@allowqueuing tinyint = 0,
							@bbcuid uniqueidentifier = NULL,
							@isnotable tinyint = 0, 
							@iscomment tinyint = 0, -- Flag to control if ThreadPostings is populated. != 0 equates to don't populate. Also indicates this is a comment, not a conversation post, so we try not to create multiple threads
							@modnotes varchar(255) = NULL -- Moderation Notes if post is entered into mod queue
AS
declare @returnthreadid int, @returnpostid int, @ispremodposting int, @ispremoderated int
SET @ispremodposting = 0
DECLARE @ReturnCode INT 
--EXEC @ReturnCode = posttoforuminternal @userid, @forumid, @inreplyto, @threadid, @subject, @content, @poststyle, @hash, @keywords, @nickname, @returnthreadid OUTPUT, @returnpostid OUTPUT, @type, @eventdate, @forcemoderate, DEFAULT, @nodeid, @ipaddress

declare @SiteQueues int
select @SiteQueues = QueuePostings from sites s WITH(NOLOCK) join Forums f WITH(NOLOCK) on s.SiteID = f.SiteID where f.ForumID = @forumid

if (@SiteQueues = 1)
BEGIN
	insert into PostingQueue (userid , 
	forumid , 
	inreplyto , 
	threadid , 
	subject , 
	content , 
	poststyle , 
	hash , 
	keywords , 
	nickname , 
	type, 
	eventdate , 
	forcemoderate, 
	forcepremoderation,
	ignoremoderation,
	clubid, 
	nodeid,
	keyphrases,
	IPAddress,
	BBCUID, 
	IsComment)
	VALUES(@userid , 
							@forumid , 
							@inreplyto , 
							@threadid , 
							@subject , 
							@content , 
							@poststyle , 
							@hash , 
							@keywords , 
							@nickname , 
							@type , 
							@eventdate , 
							@forcemoderate ,
							@forcepremoderation, 
							@ignoremoderation,
							@clubid , 
							@nodeid ,
							@keyphrases,
							@ipaddress,
							@bbcuid, 
							@iscomment
							)
	select 'ThreadID' = 0, 'PostID' = 0, 'WasQueued' = 1, 'IsPreModPosting' = 0
	return 0
END

EXEC @ReturnCode = posttoforuminternal @userid, @forumid, @inreplyto, @threadid, @subject, @content, @poststyle, @hash, @keywords, @nickname, @returnthreadid OUTPUT, @returnpostid OUTPUT, @type, @eventdate, @forcemoderate, @forcepremoderation, @ignoremoderation, DEFAULT, @nodeid, @ipaddress, NULL, @clubid, @ispremodposting OUTPUT, @ispremoderated OUTPUT, @bbcuid, @isnotable, @IsComment, @modnotes

--Update Clubs Last Updated if new post to clubs forum.
IF ( @clubid <> 0 AND ( @inreplyto Is NULL OR @inreplyto = 0 ) )
BEGIN
	EXEC @ReturnCode = forceupdateentry 0, @clubid
END

SELECT 'ThreadID' = @returnthreadid, 'PostID' = @returnpostid, 'WasQueued' = 0, 'IsPreModPosting' = @ispremodposting, 'IsPreModerated' = @ispremoderated

RETURN @ReturnCode

/*
declare @curtime datetime
declare @premoderation int
SELECT @curtime = getdate()
SELECT @premoderation = s.PreModeration FROM Forums f 
					INNER JOIN Sites s ON f.SiteID = s.SiteID
					WHERE f.ForumID = @forumid
IF (@premoderation IS NULL OR @premoderation <> 1) AND EXISTS(SELECT * from Groups g
										INNER JOIN GroupMembers m ON g.GroupID = m.GroupID
										WHERE m.UserID = @userid
										AND g.Name = 'Premoderated'
										AND g.UserInfo = 1)
BEGIN
	SELECT @premoderation = 1
END

if @forumid = 0
BEGIN
	return (0)
END

-- see if this is a duplicate post
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
SELECT 'ThreadID' = @exthreadid, 'PostID' = @expostid
return (0)
END

INSERT INTO blobs (text, type) VALUES(@content, 1)
declare @blobid int
SELECT @blobid = @@IDENTITY

IF (@inreplyto IS NULL)
BEGIN
declare @journalowner int
SELECT @journalowner = JournalOwner FROM Forums WHERE ForumID = @forumid
IF (@journalowner IS NOT NULL)
BEGIN
	return (0)
END
-- We're starting a new thread 
INSERT INTO Threads (ForumID, keywords, FirstSubject, VisibleTo) VALUES (@forumid, @keywords, CASE WHEN @premoderation = 1 THEN '' ELSE @subject END, CASE WHEN @premoderation = 1 THEN 1 ELSE NULL END)
SELECT @threadid = @@IDENTITY

INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, ForumID, Replies, CountPosts)
--VALUES(@userid, @threadid, @curtime, @curtime, @forumid, 0, 0)
SELECT UserID, @threadid, @curtime, NULL, @forumid,0,0
FROM FaveForums WHERE ForumID = @forumid AND UserID <> @userid
UNION
SELECT @userid, @threadid, @curtime, NULL, @forumid,0,0

END

INSERT INTO ThreadEntries (ThreadID, blobid, ForumID, UserID, Subject, UserName, DatePosted, Hidden)
VALUES(@threadid, @blobid, @forumid, @userid, @subject, @nickname, @curtime, CASE WHEN @premoderation = 1 THEN 3 ELSE NULL END)
declare @entryid int
SELECT @entryid = @@IDENTITY

IF (NOT (@inreplyto IS NULL))
BEGIN
-- Now we have to find out which record to attach to. 
-- We're posting as a child of the post in @inreplyto - we must insert as the last child
-- of the @inreplyto post. Therefore, we need to find a post whose NextSibling field is blank
-- and whose Parent field is @inreplyto. If this is null, we're adding the first child

declare @lastreply int, @parent int
SELECT @lastreply = EntryID FROM ThreadEntries WHERE NextSibling IS NULL AND Parent  = @inreplyto
IF (@lastreply IS NULL)
BEGIN
-- add this post as firstchild 
UPDATE ThreadEntries SET Parent = @inreplyto WHERE EntryID = @entryid
UPDATE ThreadEntries SET FirstChild = @entryid WHERE EntryID = @inreplyto
END
ELSE
BEGIN
-- Add post as last sibling 
UPDATE ThreadEntries SET PrevSibling = @lastreply, Parent = @inreplyto WHERE EntryID = @entryid
UPDATE ThreadEntries SET NextSibling = @entryid WHERE EntryID = @lastreply
END
END

UPDATE Forums SET LastPosted = DEFAULT, LastUpdated = DEFAULT WHERE ForumID = @forumid
UPDATE Threads SET LastPosted = DEFAULT, LastUpdated = DEFAULT WHERE ThreadID = @threadid

IF NOT EXISTS (SELECT * FROM ThreadPostings WHERE UserID = @userid AND ThreadID = @threadid)
BEGIN
declare @postcount int

-- note the -1 below - this is because we've already added the new post, so COUNT(*)
-- will be accurate, but since we increment the count later, we have to subtract 1
-- to end up with the same result.
SELECT @postcount = COUNT(*)-1 FROM ThreadEntries WHERE ThreadID = @threadid AND (Hidden IS NULL)
INSERT INTO ThreadPostings (UserID, ThreadID, LastPosting, LastUserPosting, ForumID, Replies, CountPosts)
VALUES(@userid, @threadid, @curtime, @curtime, @forumid, 0, @postcount)
END

UPDATE ThreadPostings
	SET LastPosting = @curtime, CountPosts = CountPosts+1, Replies = 1
		WHERE ThreadID = @threadid

UPDATE ThreadPostings
	SET LastUserPosting = @curtime, Replies = 0, LastUserPostID = @entryid
		WHERE ThreadID = @threadid AND UserID = @userid

INSERT INTO ThreadMod (ForumID, ThreadID, PostID, Status, NewPost)
VALUES(@forumid, @threadid, @entryid, 0, 1)

SELECT 'ThreadID' = @threadid, 'PostID' = @entryid
*/