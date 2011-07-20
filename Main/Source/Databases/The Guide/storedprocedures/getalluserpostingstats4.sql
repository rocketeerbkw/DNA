CREATE PROCEDURE getalluserpostingstats4 @userid int, @skip int, @show int, @siteid int
As

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	-- Check if site includes content from other sites
	DECLARE @IncludeContentFromOtherSites INT
	SELECT @IncludeContentFromOtherSites = dbo.udf_getsiteoptionsetting(@siteid, 'PersonalSpace', 'IncludeContentFromOtherSites');

;with CTE_THREADPOSTINGS as
(
			SELECT tp.ThreadID, 			
				tp.UserId
				FROM threadpostings tp WITH(NOLOCK)
				INNER JOIN Threads th WITH(NOLOCK) ON th.threadid = tp.threadid AND th.VisibleTo IS NULL
				--INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
				--INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.ThreadID = tp.ThreadID AND te.PostIndex = 0
				--INNER JOIN Users u2 WITH(NOLOCK) ON te.UserID = u2.UserID
				--INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = tp.ForumID
				--INNER JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
				--INNER JOIN SignInUserIDMapping siuidm2 WITH(NOLOCK) ON u2.UserID = siuidm2.DnaUserID
				--INNER JOIN dbo.Journals J2 WITH(NOLOCK) on J2.UserID = U2.UserID and J2.SiteID = fo.SiteID
				WHERE tp.userid=@userid
)
, CTE_USERSCONVERSATIONS as
(
			SELECT tp.ThreadID, 			
				th.FirstSubject, 
				tp.ForumID, 
				u.UserName,
				siuidm.IdentityUserID,
				'IdentityUserName' = u.LoginName,
				u.Area,
				u.FirstNames,
				u.LastName,
				u.Status,
				u.TaxonomyNode,
				u.Active,
				P.Title,
				P.SiteSuffix,
				'MostRecent' = tp.LastUserPosting,
				'LastReply' = tp.LastPosting, 
				tp.Replies, 
				'YourLastPost' = tp.LastUserPostID,
				'YourLastPostIndex' = te2.PostIndex,
				fo.SiteID, 
				'Private' = CASE WHEN th.CanRead = 0 THEN 1 ELSE 0 END,
				tp.CountPosts, 
				tp.LastPostCountRead, 
				'ForumTitle' = fo.Title,
				'Journal' = u1.UserID, 
				'JournalUserID' = u1.UserID, 
				'JournalName' = u1.UserName, 
				'JournalFirstNames' = u1.FirstNames,
				'JournalLastName' = u1.LastName, 
				'JournalArea' = u1.Area,
				'JournalTitle' = NULL,
				'JournalSiteSuffix' = NULL,
				'FirstPosterUserID' = u2.UserID, 
				'FirstPosterUsername' = u2.UserName,
				'FirstPosterIdentityUserID' = siuidm2.IdentityUserID, 
				'FirstPosterIdentityUserName' = u2.LoginName, 
				'FirstPosterFirstNames' = u2.FirstNames, 
				'FirstPosterLastName' = u2.LastName,
				'FirstPosterArea' = u2.Area,
				'FirstPosterStatus' = u2.Status,
				'FirstPosterTaxonomyNode' = u2.TaxonomyNode,
				'FirstPosterJournal' = J2.ForumID,
				'FirstPosterActive' = u2.Active,
				'FirstPosterTitle'= P2.Title,
				'FirstPosterSiteSuffix' = P2.SiteSuffix,
				th.Type,
				th.EventDate,
				'DateFirstPosted' = te.DatePosted, 
				CASE WHEN (so.SiteID IS NULL AND fo.SiteID<>@siteid) THEN 0 ELSE 1 END AS 'IsPostingFromVisibleSite'

				FROM threadpostings tp WITH(NOLOCK)
				INNER JOIN Threads th WITH(NOLOCK) ON th.threadid = tp.threadid AND th.VisibleTo IS NULL
				INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
				INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.ThreadID = tp.ThreadID AND te.PostIndex = 0
				INNER JOIN Users u2 WITH(NOLOCK) ON te.UserID = u2.UserID
				INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = tp.ForumID
				LEFT JOIN SiteOptions so ON so.SiteID= fo.SiteID AND so.Section = 'General' AND so.Name = 'SiteIsPrivate' AND so.value='0' AND @IncludeContentFromOtherSites = 1 -- i.e. All public sites if current site includes content from other sites. 
				LEFT JOIN Users u1 WITH(NOLOCK) ON fo.JournalOwner = u1.UserID
				LEFT JOIN Preferences P WITH(NOLOCK) on (P.UserID = U.UserID) and (P.SiteID = fo.SiteID)
				LEFT JOIN Preferences P2 WITH(NOLOCK) on (P2.UserID = U2.UserID) and (P2.SiteID = fo.SiteID)
				INNER JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
				INNER JOIN SignInUserIDMapping siuidm2 WITH(NOLOCK) ON u2.UserID = siuidm2.DnaUserID
				INNER JOIN dbo.Journals J2 WITH(NOLOCK) on J2.UserID = U2.UserID and J2.SiteID = fo.SiteID
				LEFT JOIN dbo.ThreadEntries te2 WITH(NOLOCK) ON te2.EntryID = tp.LastUserPostID
				WHERE tp.userid=@userid
)
,
	CTE_USERSCONVERSATIONS_PAGINATION AS
	(
		SELECT row_number() over ( order by uc.LastReply DESC) as n, uc.*
		FROM CTE_USERSCONVERSATIONS uc
	)		

	SELECT ucp.* 
		,'Total' = (select count(*) FROM CTE_THREADPOSTINGS)
	FROM CTE_USERSCONVERSATIONS_PAGINATION ucp				
	WHERE ucp.n > @skip AND ucp.n <= @skip + @show
	ORDER BY n
