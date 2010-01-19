CREATE PROCEDURE postprivatealertmessage @sendtouserid int, @siteid int, @subject varchar(256), @message varchar(4000), @hash uniqueidentifier
AS
DECLARE @Error int, @ForumID int, @SentFromUserID int, @ReturnThread int, @ReturnPost int
-- Get the private forum for the user
SELECT @ForumID = t.ForumID FROM Teams t WITH(NOLOCK)
INNER JOIN UserTeams u WITH(NOLOCK) ON u.TeamID = t.TeamID AND u.SiteID = @siteid
WHERE u.UserID = @sendtouserid

if @forumID IS NULL
BEGIN
	SELECT 'ReturnThreadID' = 0, 'ReturnPostID' = 0
	return 15
END

-- Now get the default sent from userid from the sites id
SELECT @SentFromUserID = AutoMessageUserID FROM Sites WITH(NOLOCK) WHERE SiteID = @siteid

-- Now post the message with all the calculated params
EXEC @Error = posttoforuminternal @SentFromUserID,		-- UserID
									 @ForumID,				-- ForumID
									 NULL,					-- InReplyTo
									 NULL,					-- ThreadID
									 @subject,				-- Subject
									 @message,				-- Content
									 2,						-- PostStyle
									 @hash,					-- Hash
									 NULL,					-- KeyWords
									 NULL,					-- NickName
									 @ReturnThread OUTPUT,	-- NewThreadID
									 @ReturnPost OUTPUT,	-- NewPostID
									 NULL,					-- Type
									 NULL,					-- EventDate
									 0,						-- ForceModerateAndHide
									 0,						-- Ignore moderation
									 0,						-- AllowEventEntries
									 DEFAULT,				-- NodeID
									 DEFAULT,				-- IP address
									 DEFAULT,				-- Queue ID
									 DEFAULT,				-- clubid
									 NULL,					-- Is Premod Posting
									 DEFAULT,				-- BBCUID
									 DEFAULT,				-- @isnotable
									 DEFAULT				-- @iscomment
									 
SELECT 'ReturnThreadID' = @ReturnThread, 'ReturnPostID' = @ReturnPost
RETURN @Error
