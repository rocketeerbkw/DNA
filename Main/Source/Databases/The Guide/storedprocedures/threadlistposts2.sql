/*
New version for Ripley which handles hidden posts properly
*/

CREATE   PROCEDURE threadlistposts2 @threadid int, @start int = 0, @end int = 2100000000
AS
declare @numposts int
SELECT @numposts = MAX(PostIndex)+1 FROM ThreadEntries t WITH(NOLOCK)
INNER JOIN Threads th WITH(NOLOCK) ON th.ThreadID = t.ThreadID
WHERE t.ThreadID = @threadid AND th.VisibleTo IS NULL -- AND (t.Hidden IS NULL)

declare @editgroup int
select @editgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = 'Editor'
declare @notablesgroup int
select @notablesgroup = GroupID FROM Groups WITH(NOLOCK) WHERE Name = 'Notables'

		SELECT 
			t.ForumID, 
			t.ThreadID, 
			t.UserID, 
			u.FirstNames, 
			u.LastName, 
			u.Area,
			P.Title,
			p.SiteSuffix,
			u.Status, u.TaxonomyNode, 'Journal' = j.ForumID, u.Active,
			'UserName' = CASE WHEN LTRIM(u.UserName) = '' THEN 'Researcher ' + CAST(u.UserID AS varchar) ELSE u.UserName END, 
			'Subject' = CASE Subject WHEN '' THEN 'No Subject' ELSE Subject END, 
			NextSibling, 
			PrevSibling, 
			Parent, 
			FirstChild, 
			EntryID, 
			DatePosted, 
			t.LastUpdated,
			Hidden,
			f.SiteID,
			'Interesting' = NULL,
			'Total' = @numposts,
			'Editor' = CASE WHEN gm.UserID IS NOT NULL THEN 1 ELSE 0 END,
			'Notable' = CASE WHEN gm2.UserID IS NOT NULL THEN 1 ELSE 0 END,
			th.CanRead,
			th.CanWrite,
			t.PostStyle,
			gm.*,
			t.text,
			'FirstPostSubject' = th.FirstSubject,
			f.ForumPostCount + (select SUM(PostCountDelta) FROM ForumPostCountAdjust WITH(NOLOCK) WHERE ForumID = f.ForumID),
			f.AlertInstantly,
			th.Type,
			th.eventdate,
			'threadlastupdate' = th.lastupdated
	FROM ThreadEntries t WITH(NOLOCK)
		INNER JOIN Users u WITH(NOLOCK) ON t.UserID = u.UserID
		INNER JOIN Threads th WITH(NOLOCK) ON t.ThreadID = th.ThreadID
		INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = t.ForumID
		LEFT JOIN Preferences p WITH(NOLOCK) on (p.UserID = u.UserID) AND (p.SiteID = f.SiteID)
		LEFT JOIN GroupMembers gm WITH(NOLOCK) ON gm.UserID = t.UserID AND gm.SiteID = f.SiteID AND gm.GroupID = @editgroup
		LEFT JOIN GroupMembers gm2 WITH(NOLOCK) ON gm2.UserID = t.UserID AND gm2.SiteID = f.SiteID AND gm2.GroupID = @notablesgroup
		INNER JOIN Journals J with(nolock) on J.UserID = U.UserID and J.SiteID = f.SiteID
	WHERE t.ThreadID = @threadid AND t.PostIndex >= @start AND t.PostIndex <= @end AND th.VisibleTo IS NULL -- AND (t.Hidden IS NULL) 
	ORDER BY PostIndex
	OPTION (OPTIMIZE FOR(@threadid=0)) -- Protect against dodgy execution plans after a recompile
	