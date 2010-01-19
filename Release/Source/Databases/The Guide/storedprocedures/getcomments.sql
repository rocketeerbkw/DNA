CREATE PROCEDURE getcomments @forumid int, @frompostindex int = 0, @topostindex int = 19
as
declare @forumpostcount int, @siteid int
select @forumpostcount = ForumPostCount, @siteid=siteid from Forums WITH(NOLOCK) where ForumID = @forumid
select @forumpostcount = @forumpostcount + isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = @forumid

IF @forumpostcount > 0
BEGIN
	SELECT  
		t.EntryID, 
		t.ForumID, 
		t.ThreadID,
		t.PostIndex, 
		t.UserID, 
		u.FirstNames, 
		u.LastName, 
		u.Area,
		u.Status,
		u.TaxonomyNode,
		'Journal' = J.ForumID,
		u.Active,
		p.Title,
		p.SiteSuffix,
		'UserName' = CASE WHEN LTRIM(u.UserName) = '' THEN 'Researcher ' + CAST(u.UserID AS varchar) ELSE u.UserName END, 
		'Subject' = CASE Subject WHEN '' THEN 'No Subject' ELSE Subject END, 
		NextSibling, 
		PrevSibling, 
		Parent, 
		FirstChild, 
		DatePosted, 
		Hidden,
		f.SiteID,
		'Interesting' = NULL,
		'ForumCanRead' = f.CanRead,
		'ForumCanWrite' = f.CanWrite,
		th.CanRead,
		th.CanWrite,
		t.PostStyle,
		t.text,
		'ForumPostCount' = @forumpostcount,
		f.AlertInstantly,
		f.ModerationStatus,
		cf.URL,
		cf.ForumCloseDate,
		'From' = @frompostindex,
		'To' = @topostindex,
		'VisibleTo' = th.VisibleTo,
		'CommentForumTitle' = f.Title
	FROM ThreadEntries t WITH(NOLOCK)
		INNER JOIN Users u WITH(NOLOCK) ON t.UserID = u.UserID
		INNER JOIN Threads th WITH(NOLOCK) ON t.ThreadID = th.ThreadID
		INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = t.ForumID
		INNER JOIN CommentForums cf WITH(NOLOCK)ON cf.ForumID = f.ForumID
		INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @SiteID
		LEFT JOIN Preferences p WITH(NOLOCK) on (p.UserID = u.UserID) and (p.SiteID = @SiteID)
	WHERE f.ForumID = @forumid
	AND	t.PostIndex BETWEEN @frompostindex AND @topostindex
	ORDER BY t.PostIndex
	
END
ELSE
BEGIN
SELECT 'ForumID' = @forumid, 'ThreadID' = NULL, 'ForumCanRead' = f.CanRead, 'ForumCanWrite' = f.CanWrite, 
f.SiteID, 'ForumPostCount' = @forumpostcount, AlertInstantly, f.ModerationStatus, cf.URL,
'From' = 0, 'To' = 0 ,th.VisibleTo, cf.ForumCloseDate, 'CommentForumTitle' = f.Title
FROM Forums f WITH(NOLOCK) 
INNER JOIN CommentForums cf WITH(NOLOCK) on cf.ForumID = f.ForumID
LEFT JOIN Threads th WITH(NOLOCK) ON th.ForumId = cf.ForumId 
WHERE f.ForumID = @forumid
END
