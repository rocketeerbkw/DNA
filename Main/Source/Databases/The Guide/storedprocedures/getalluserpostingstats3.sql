CREATE PROCEDURE getalluserpostingstats3 @userid int, @startindex int =20, @itemsperpage int=0, @siteid int
As

-- @maxresults is used to limit the number of results returned for popular values
-- NOTE: The TOP value is 1 more than the num results requested (e.g. TOP 26 for the "25" case)
--       This lets DNA know if there are more posts available
--
-- NOTE: If you change this SP, change related SP getalluserpostingstatsbasic.sql

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		-- Check if site includes content from other sites
		DECLARE @IncludeContentFromOtherSites INT
		SELECT @IncludeContentFromOtherSites = dbo.udf_getsiteoptionsetting(@siteid, 'PersonalSpace', 'IncludeContentFromOtherSites');


		;with CTE_POSTINGS AS
		(
			select 
				row_number() over(order by tp.lastposting desc) n,			
				tp.userid, tp.threadid, tp.forumid
			from 
				threadpostings tp
			where
				tp.userid = @userid
		)
		,
		CTE_TOTAL AS
		(
			SELECT (SELECT CAST(MAX(n) AS INT) FROM CTE_EVENTS) AS 'total', * FROM CTE_POSTINGS
		)
		SELECT	tp.ThreadID, 
				tp.FirstSubject, 
				tp.ForumID, 
				u.UserName,
				siuidm.IdentityUserID,
				'IdentityUserName' = u.LoginName,
				u.Area,
				u.FirstNames,
				u.LastName,
				u.Status,
				u.TaxonomyNode,
				--'UserJournal' = J1.ForumID, -- Removed because it's never used and impossible to infer without SiteID input
				u.Active,
				P.Title,
				P.SiteSuffix,
				'MostRecent' = tp.LastUserPosting,
				'LastReply' = tp.LastPosting, 
				tp.Replies, 
				'YourLastPost' = tp.LastUserPostID,
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
		INNER JOIN Users u2 WITH(NOLOCK) ON u2.UserID = te.userid 
		INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = th.ForumID
		LEFT JOIN SiteOptions so ON so.SiteID= fo.SiteID AND so.Section = 'General' AND so.Name = 'SiteIsPrivate' AND so.value='0' AND @IncludeContentFromOtherSites = 1 -- i.e. All public sites if current site includes content from other sites. 
		LEFT JOIN Users u1 WITH(NOLOCK) ON fo.JournalOwner = u1.UserID
		LEFT JOIN Preferences P WITH(NOLOCK) on (P.UserID = U.UserID) and (P.SiteID = fo.SiteID)
		LEFT JOIN Preferences P2 WITH(NOLOCK) on (P2.UserID = U2.UserID) and (P2.SiteID = fo.SiteID)
		INNER JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
		INNER JOIN SignInUserIDMapping siuidm2 WITH(NOLOCK) ON u2.UserID = siuidm2.DnaUserID
		--INNER JOIN dbo.Journals J1 WITH(NOLOCK) on J1.UserID = U.UserID and J1.SiteID = fo.SiteID
		INNER JOIN dbo.Journals J2 WITH(NOLOCK) on J2.UserID = U2.UserID and J2.SiteID = fo.SiteID
		where 
		n > @startindex and n <= @startindex + @itemsperpage
		ORDER BY n
		
