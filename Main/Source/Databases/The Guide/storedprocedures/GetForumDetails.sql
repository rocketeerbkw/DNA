CREATE PROCEDURE getforumdetails @itemid int, @itemtype int, @userid int
AS
DECLARE @ForumType int, @ThreadType int, @PostType int
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT
EXEC SetItemTypeValInternal 'IT_POST', @PostType OUTPUT

IF (@itemtype = @ForumType)
BEGIN
	SELECT	'UsersPrivateForum' = CASE WHEN tm.forumid IS NOT NULL AND tm.forumid = f.ForumID THEN 1 ELSE 0 END,
			f.ForumID,
			f.AlertInstantly,
			'ThreadID' = 0
		FROM dbo.Forums f WITH(NOLOCK)
		LEFT JOIN dbo.UserTeams u WITH(NOLOCK) ON u.UserID = @userid AND u.SiteID = f.SiteID
		LEFT JOIN dbo.Teams tm WITH(NOLOCK) ON tm.TeamID = u.TeamID
		WHERE f.ForumID = @itemid
END
ELSE IF (@itemtype = @ThreadType)
BEGIN
	SELECT	'UsersPrivateForum' = CASE WHEN tm.forumid IS NOT NULL AND tm.forumid = f.ForumID THEN 1 ELSE 0 END,
			f.ForumID,
			f.AlertInstantly,
			'ThreadID' = @itemid
		FROM dbo.Forums f WITH(NOLOCK)
		INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ForumID = f.ForumID
		LEFT JOIN dbo.UserTeams u WITH(NOLOCK) ON u.UserID = @userid AND u.SiteID = f.SiteID
		LEFT JOIN dbo.Teams tm WITH(NOLOCK) ON tm.TeamID = u.TeamID
		WHERE t.ThreadID = @itemid
END
ELSE IF (@itemtype = @PostType)
BEGIN
	SELECT	'UsersPrivateForum' = CASE WHEN tm.forumid IS NOT NULL AND tm.forumid = f.ForumID THEN 1 ELSE 0 END,
			f.ForumID,
			f.AlertInstantly,
			te.ThreadID
		FROM dbo.Forums f WITH(NOLOCK)
		INNER JOIN dbo.ThreadEntries te WITH(NOLOCK) ON te.ForumID = f.ForumID
		LEFT JOIN dbo.UserTeams u WITH(NOLOCK) ON u.UserID = @userid AND u.SiteID = f.SiteID
		LEFT JOIN dbo.Teams tm WITH(NOLOCK) ON tm.TeamID = u.TeamID
		WHERE te.EntryID = @itemid
END