CREATE PROCEDURE getlatestcomments @forumid int, @show int = 20
AS
DECLARE @forumpostcount int
SELECT @forumpostcount = ForumPostCount FROM Forums WITH(NOLOCK) WHERE ForumID = @forumid
SELECT @forumpostcount = @forumpostcount + isnull(sum(PostCountDelta),0) FROM ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = @forumid

DECLARE @numbertoget int
DECLARE @from int
DECLARE @to int
SET @numbertoget = (@forumpostcount % @show) + @show
SET @to = @forumpostcount - 1
SET @from = @forumpostcount - @numbertoget

IF @forumpostcount > 0
BEGIN
	SELECT TOP (@numbertoget)
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
		'From' = @from,
		'To' = @to,
		'Show' = @show,
		cf.URL,
		cf.ForumCloseDate,
		th.VisibleTo,
		'CommentForumTitle' = f.Title
	FROM ThreadEntries t WITH(NOLOCK)
		INNER JOIN Users u WITH(NOLOCK) ON t.UserID = u.UserID
		INNER JOIN Threads th WITH(NOLOCK) ON t.ThreadID = th.ThreadID
		INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = t.ForumID
		LEFT JOIN Preferences p WITH(NOLOCK) on (p.UserID = u.UserID) and (p.SiteID = f.SiteID)
		INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = f.SiteID
		LEFT JOIN CommentForums cf WITH(NOLOCK)ON cf.ForumID = f.ForumID
	WHERE f.ForumID = @forumid
	ORDER BY t.PostIndex DESC

END
ELSE
BEGIN

	-- No posts to return ( New Forum or Thread has been hidden due to moderation ).
	SELECT 'ForumID' = @forumid, 'ThreadID' = NULL, 'ForumCanRead' = f.CanRead, 'ForumCanWrite' = f.CanWrite, 'From' = @from, 'To' = @to, 'Show' = @show,
	f.SiteID, 'ForumPostCount' = @forumpostcount, AlertInstantly, f.ModerationStatus, cf.URL, th.VisibleTo, cf.ForumCloseDate, 'CommentForumTitle' = f.Title
	FROM Forums f WITH(NOLOCK) 
	INNER JOIN CommentForums cf WITH(NOLOCK) on cf.ForumID = f.ForumID
	LEFT JOIN Threads th WITH(NOLOCK) ON th.forumid = cf.forumid
	WHERE f.ForumID = @forumid
END

