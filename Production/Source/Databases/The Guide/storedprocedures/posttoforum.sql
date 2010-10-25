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

EXEC @ReturnCode = posttoforuminternal  @userid, @forumid, @inreplyto, @threadid, @subject, @content, @poststyle, @hash, @keywords, @nickname, @returnthreadid OUTPUT, 
										@returnpostid OUTPUT, @type, @eventdate, @forcemoderate, @forcepremoderation, @ignoremoderation, DEFAULT, @nodeid, @ipaddress, 
										NULL, @clubid, @ispremodposting OUTPUT, @ispremoderated OUTPUT, @bbcuid, @isnotable, @IsComment, @modnotes,
										/*@isthreadedcomment*/ 0,/*@ignoreriskmoderation*/ 0

--Update Clubs Last Updated if new post to clubs forum.
IF ( @clubid <> 0 AND ( @inreplyto Is NULL OR @inreplyto = 0 ) )
BEGIN
	EXEC @ReturnCode = forceupdateentry 0, @clubid
END

SELECT 'ThreadID' = @returnthreadid, 'PostID' = @returnpostid, 'WasQueued' = 0, 'IsPreModPosting' = @ispremodposting, 'IsPreModerated' = @ispremoderated

RETURN @ReturnCode

