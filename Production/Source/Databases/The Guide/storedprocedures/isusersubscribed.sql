CREATE PROCEDURE isusersubscribed @userid int, @threadid int, @forumid int
as
declare @threadsub int, @forumsub int, @lastposting int, @lastpostcountread int
SELECT TOP 1 @lastposting = LastUserPostID, @lastpostcountread = LastPostCountRead FROM ThreadPostings WITH(NOLOCK) WHERE UserID = @userid AND ThreadID = @threadid
IF @lastpostcountread IS NOT NULL
	SELECT @threadsub = 1
ELSE
	SELECT @threadsub = 0

IF EXISTS (SELECT * FROM FaveForums WITH(NOLOCK) WHERE UserID = @userid AND ForumID = @forumid)
	SELECT @forumsub = 1
ELSE
	SELECT @forumsub = 0

SELECT 'ForumSubscribed' = @forumsub, 'ThreadSubscribed' = @threadsub, 'LastPostCountRead' = @lastpostcountread, 'LastUserPostID' = @lastposting