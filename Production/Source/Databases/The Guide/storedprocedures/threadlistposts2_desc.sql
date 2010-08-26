/*
New version for Ripley which handles hidden posts properly
rows sorted by date create in descing order
same as threadlistposts2, but sort order is different
adderd for FilmNetworks, see task 52 on sprint 23
*/

CREATE   PROCEDURE threadlistposts2_desc @threadid int, @start int = 0, @end int = 2100000000
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
			siuidm.IdentityUserId,
			'IdentityUserName'	= u.LoginName, 
			u.FirstNames, 
			u.LastName, 
			u.Area,
			P.Title,
			p.SiteSuffix,
			u.Status, u.TaxonomyNode, 'Journal' = j.forumid, u.Active,
			'UserName' = CASE WHEN LTRIM(u.UserName) = '' THEN 'Researcher ' + CAST(u.UserID AS varchar) ELSE u.UserName END, 
			'Subject' = CASE t.Subject WHEN '' THEN 'No Subject' ELSE t.Subject END, 
			t.NextSibling, 
			t.PrevSibling, 
			t.Parent, 
			t.FirstChild, 
			t.EntryID, 
			t.DatePosted, 
			t.LastUpdated,
			t.Hidden,
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
			f.ForumPostCount,
			f.AlertInstantly,
			th.Type,
			th.eventdate,
			'threadlastupdate' = th.lastupdated,
			te.postindex as 'replypostindex'
	FROM ThreadEntries t WITH(NOLOCK)
		LEFT JOIN ThreadEntries te on te.entryid=t.parent
		INNER JOIN Users u WITH(NOLOCK) ON t.UserID = u.UserID
		LEFT JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
		INNER JOIN Threads th WITH(NOLOCK) ON t.ThreadID = th.ThreadID
		INNER JOIN Forums f WITH(NOLOCK) on f.ForumID = t.ForumID
		LEFT JOIN Preferences p WITH(NOLOCK) on (p.UserID = u.UserID) AND (p.SiteID = f.SiteID)
		LEFT JOIN GroupMembers gm WITH(NOLOCK) ON gm.UserID = t.UserID AND gm.SiteID = f.SiteID AND gm.GroupID = @editgroup
		LEFT JOIN GroupMembers gm2 WITH(NOLOCK) ON gm2.UserID = t.UserID AND gm2.SiteID = f.SiteID AND gm2.GroupID = @notablesgroup
		INNER JOIN Journals J with(nolock) on J.UserID = U.UserID and J.SiteID = f.SiteID
	WHERE t.ThreadID = @threadid AND t.PostIndex >= @start AND t.PostIndex <= @end AND th.VisibleTo IS NULL -- AND (t.Hidden IS NULL) 
	ORDER BY t.PostIndex DESC 
