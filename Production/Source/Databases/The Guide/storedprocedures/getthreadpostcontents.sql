CREATE PROCEDURE getthreadpostcontents @postid int, @userid int
AS

declare @threadid int, @canread int, @canwrite int
select @threadid = ThreadID FROM ThreadEntries WITH(NOLOCK) WHERE EntryID = @postid

select TOP 1 @canread = CASE WHEN gm.UserID IS NULL THEN t.CanRead ELSE tp.CanRead END,
		@canwrite = CASE WHEN gm.UserID IS NULL THEN t.CanWrite ELSE tp.CanWrite END from Threads t WITH(NOLOCK)
LEFT JOIN ThreadPermissions tp WITH(NOLOCK) ON tp.ThreadID = t.ThreadID
LEFT JOIN (SELECT u.UserID, g.TeamID FROM Users u WITH(NOLOCK) INNER JOIN TeamMembers g WITH(NOLOCK) ON u.UserID = g.UserID) as gm ON gm.TeamID = tp.TeamID AND gm.UserID = @userid
WHERE t.ThreadID = @threadid
order by gm.UserID DESC, tp.Priority DESC

SELECT	t.ThreadID,
		t.EntryID,
		t.ForumID,
		'Subject' = CASE WHEN t.Hidden IS NOT NULL THEN 'Hidden' ELSE Subject END, 
		'UserID' = CASE WHEN t.Hidden IS NOT NULL THEN 0 ELSE t.UserID END, 
		'UserName' = CASE WHEN t.Hidden IS NOT NULL THEN 'Hidden' ELSE u.UserName END, 
		'SiteSuffix' = CASE WHEN t.Hidden IS NOT NULL THEN 'Hidden' ELSE p.SiteSuffix END,
		'text' = CASE WHEN t.Hidden IS NOT NULL THEN 'Hidden' ELSE t.text END,
		'CanRead' = @canread,
		'CanWrite' = @canwrite,
		t.PostStyle,
		t.PostIndex
FROM ThreadEntries t WITH(NOLOCK)
INNER JOIN Users u WITH(NOLOCK) ON u.UserID = t.UserID
INNER JOIN Forums f WITH(NOLOCK) ON f.ForumID = t.ForumID
INNER JOIN Preferences p WITH(NOLOCK) ON p.SiteID = f.SiteID AND p.UserID = u.UserID
WHERE t.EntryID = @postid