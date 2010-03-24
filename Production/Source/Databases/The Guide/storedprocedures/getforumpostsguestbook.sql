CREATE PROCEDURE getforumpostsguestbook @forumid int, @ascendingorder int = 0
as
declare @numposts int
SELECT @numposts = COUNT(*) FROM ThreadEntries t WITH(NOLOCK)
INNER JOIN Threads th WITH(NOLOCK) ON th.ThreadID = t.ThreadID
WHERE t.ForumID = @forumid AND th.VisibleTo IS NULL -- AND (t.Hidden IS NULL)

declare @editgroup int
select @editgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = 'Editor'

declare @notablesgroup int
select @notablesgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = 'Notables'

declare @forumpostcount int
select @forumpostcount = ForumPostCount from Forums WITH(NOLOCK) where ForumID = @forumid
select @forumpostcount = @forumpostcount + isnull(sum(PostCountDelta),0) from ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = @forumid


IF @numposts > 0
BEGIN
	IF @ascendingorder = 0
	BEGIN
		SELECT 
			t.ForumID, 
			t.ThreadID, 
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
			EntryID, 
			DatePosted, 
			Hidden,
			f.SiteID,
			'Interesting' = NULL,
			'Total' = @numposts,
			'Editor' = CASE WHEN gm.UserID IS NOT NULL THEN 1 ELSE 0 END,
			'Notable' = CASE WHEN gm1.UserID IS NOT NULL THEN 1 ELSE 0 END,
			th.CanRead,
			th.CanWrite,
			t.PostStyle,
			gm.*,
			t.text,
			'ForumPostCount' = @forumpostcount,
			f.AlertInstantly
		FROM ThreadEntries t WITH(NOLOCK)
			INNER JOIN Users u WITH(NOLOCK) ON t.UserID = u.UserID
			INNER JOIN Threads th WITH(NOLOCK) ON t.ThreadID = th.ThreadID
			INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = t.ForumID
			LEFT JOIN Preferences p WITH(NOLOCK) on (p.UserID = u.UserID) and (p.SiteID = f.SiteID)
			INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = f.SiteID
			LEFT JOIN GroupMembers gm WITH(NOLOCK) ON gm.UserID = t.UserID AND gm.SiteID = f.SiteID AND gm.GroupID = @editgroup 
			LEFT JOIN GroupMembers gm1 WITH(NOLOCK) ON gm1.UserID = t.UserID AND gm1.SiteID = f.SiteID AND gm1.GroupID = @notablesgroup
		WHERE f.ForumID = @forumid AND th.VisibleTo IS NULL -- AND (t.Hidden IS NULL) 
		ORDER BY DatePosted DESC
	END
	ELSE
	BEGIN
		SELECT 
			t.ForumID, 
			t.ThreadID, 
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
			EntryID, 
			DatePosted, 
			Hidden,
			f.SiteID,
			'Interesting' = NULL,
			'Total' = @numposts,
			'Editor' = CASE WHEN gm.UserID IS NOT NULL THEN 1 ELSE 0 END,
			'Notable' = CASE WHEN gm1.UserID IS NOT NULL THEN 1 ELSE 0 END,
			th.CanRead,
			th.CanWrite,
			t.PostStyle,
			gm.*,
			t.text,
			'ForumPostCount' = @forumpostcount,
			f.AlertInstantly
		FROM ThreadEntries t WITH(NOLOCK)
			INNER JOIN Users u WITH(NOLOCK) ON t.UserID = u.UserID
			INNER JOIN Threads th WITH(NOLOCK) ON t.ThreadID = th.ThreadID
			INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = t.ForumID
			LEFT JOIN Preferences p WITH(NOLOCK) on (p.UserID = u.UserID) and (p.SiteID = f.SiteID)
			INNER JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = f.SiteID
			LEFT JOIN GroupMembers gm WITH(NOLOCK) ON gm.UserID = t.UserID AND gm.SiteID = f.SiteID AND gm.GroupID = @editgroup 
			LEFT JOIN GroupMembers gm1 WITH(NOLOCK) ON gm1.UserID = t.UserID AND gm1.SiteID = f.SiteID AND gm1.GroupID = @notablesgroup
		WHERE f.ForumID = @forumid AND th.VisibleTo IS NULL -- AND (t.Hidden IS NULL) 
		ORDER BY DatePosted ASC
	END
END
ELSE
BEGIN
	SELECT 'ForumID' = @forumid, 'ThreadID' = NULL, 'Total' = @numposts, CanRead, CanWrite, SiteID, 'ForumPostCount' = @forumpostcount, AlertInstantly FROM Forums WITH(NOLOCK) WHERE ForumID = @forumid
END