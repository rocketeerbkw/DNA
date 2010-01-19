CREATE PROCEDURE getallusernoticepostings @userid int, @showuserhidden bit = 0, @siteid int
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	-- Check if site includes content from other sites
	DECLARE @IncludeContentFromOtherSites INT
	SELECT @IncludeContentFromOtherSites = dbo.udf_getsiteoptionsetting(@siteid, 'PersonalSpace', 'IncludeContentFromOtherSites');

	SELECT	t.ThreadID, 
			te.Subject 'FirstSubject', 
			te.EntryID 'FirstPostID',
			t.ForumID,
			u.UserName,
			u.Area,
			u.FirstNames,
			u.LastName,
			u.Status,
			u.TaxonomyNode,
			'UserJournal' = J1.ForumID,
			u.Active,
			P.Title,
			P.SiteSuffix,
			'MostRecent' = t.LastUserPosting,
			'LastReply' = t.LastPosting, t.Replies, 'YourLastPost' = t.LastUserPostID,
			fo.SiteID, 'Private' = CASE WHEN f.CanRead = 0 THEN 1 ELSE 0 END,
			t.CountPosts, t.LastPostCountRead, 'ForumTitle' = fo.Title,
			'Journal' = u1.UserID, 'JournalName' = u1.UserName, 'JournalFirstNames' = u1.FirstNames,
			'JournalLastName' = u1.LastName, 'JournalArea' = u1.Area,
			'JournalTitle' = NULL, 'JournalSiteSuffix' = NULL,
			'FirstPosterUserID' = u2.UserID, 
			'FirstPosterUsername' = u2.UserName,
			'FirstPosterFirstNames' = u2.FirstNames, 
			'FirstPosterLastName' = u2.LastName,
			'FirstPosterArea' = u2.Area,
			'FirstPosterStatus' = u2.Status,
			'FirstPosterTaxonomyNode' = u2.TaxonomyNode,
			'FirstPosterJournal' = J2.ForumID,
			'FirstPosterActive' = u2.Active,
			'FirstPosterTitle'= P2.Title,
			'FirstPosterSiteSuffix' = P2.SiteSuffix,
			f.Type,
			f.EventDate,
			'DateFirstPosted' = te.DatePosted,
			te.Hidden, 
			CASE WHEN (so.SiteID IS NULL AND fo.SiteID<>@siteid) THEN 0 ELSE 1 END AS 'IsPostingFromVisibleSite'
	FROM	dbo.ThreadPostings t WITH(NOLOCK)
			INNER JOIN dbo.Threads f WITH(NOLOCK) ON f.ThreadID = t.ThreadID
			INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = t.UserID 
			INNER JOIN dbo.ThreadEntries te WITH(NOLOCK) ON te.ThreadID = t.ThreadID AND te.PostIndex = 0
			INNER JOIN dbo.Users u2 WITH(NOLOCK) ON te.UserID = u2.UserID
			INNER JOIN dbo.Forums fo WITH(NOLOCK) ON fo.ForumID = t.ForumID 
			LEFT JOIN SiteOptions so ON so.SiteID= fo.SiteID AND so.Section = 'General' AND so.Name = 'SiteIsPrivate' AND so.value='0' AND @IncludeContentFromOtherSites = 1 -- i.e. All public sites if current site includes content from other sites. 
			LEFT JOIN dbo.Users u1 WITH(NOLOCK) ON fo.JournalOwner = u1.UserID
			LEFT JOIN dbo.Preferences P WITH(NOLOCK) on (P.UserID = U.UserID) and (P.SiteID = fo.SiteID)
			LEFT JOIN dbo.Preferences P2 WITH(NOLOCK) on (P2.UserID = U2.UserID) and (P2.SiteID = fo.SiteID)
			INNER JOIN dbo.Journals J1 WITH(NOLOCK) on J1.UserID = U.UserID and J1.SiteID = fo.SiteID
			INNER JOIN dbo.Journals J2 WITH(NOLOCK) on J2.UserID = U2.UserID and J2.SiteID = fo.SiteID
	WHERE	t.UserID = @userid AND f.Type = 'Notice'
	AND		(f.VisibleTo IS NULL OR (@showuserhidden = 1 AND te.Hidden = 7) ) -- pull out user-hidden notices.
	ORDER	BY LastReply DESC