create procedure getusercommentsstats @userid int, @siteid int, @firstindex int, @lastindex int
as

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH Comments as
	(
		SELECT entryid, uc.siteid
			FROM VUserComments uc WITH(NOEXPAND)
			WHERE uc.userid=@userid
	),
	PublicSites as
	(
		SELECT s.SiteID FROM Sites s WHERE s.SiteID NOT IN
		(
			SELECT so.SiteID FROM SiteOptions so WHERE so.Section = 'General' AND so.Name = 'SiteIsPrivate' AND so.value='1'
		) AND s.Siteid <> @SiteID
		UNION ALL
		SELECT @siteid
	),
	VisibleComments as
	(
		select c.*, ROW_NUMBER() OVER(ORDER BY te.DatePosted DESC) rn
			FROM comments c
			INNER JOIN PublicSites ps ON c.siteid=ps.siteid
			INNER JOIN threadentries te ON te.entryid=c.entryid AND te.Hidden IS NULL
			INNER JOIN Threads th ON th.threadid = te.threadid AND th.VisibleTo IS NULL
	)
	SELECT 
		vc.EntryID,
		te.ThreadID,
		f.ForumID,
		te.Subject,
		te.PostIndex,
		te.Text,
		te.DatePosted,
		te.PostStyle,
		u.UserName,
		u.Area,
		u.FirstNames,
		u.LastName,
		u.Status,
		u.TaxonomyNode,
		u.Active,
		p.SiteSuffix,
		cf.SiteID, 
		f.ForumPostCount,
		'ForumTitle' = f.Title,
		cf.URL,
		cf.ForumCloseDate,
		vc.rn

	from VisibleComments vc
	inner join ThreadEntries te on te.entryid = vc.entryid
	inner join Users u on u.UserID = @userid
	inner join Forums f on f.ForumID = te.ForumID
	inner join CommentForums cf on cf.ForumID = f.ForumID
	left join dbo.Preferences p on p.UserId = @userid AND p.SiteID = @SiteID
	where (vc.rn BETWEEN (@firstindex+1) AND (@lastindex+1))
	Order By vc.rn 
