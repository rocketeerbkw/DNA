CREATE PROCEDURE getalluserpostingstats3 @userid int, @maxresults int, @siteid int
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

		SELECT	tpth.ThreadID, 
				tpth.FirstSubject, 
				tpth.ForumID, 
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
				'MostRecent' = tpth.LastUserPosting,
				'LastReply' = tpth.LastPosting, 
				tpth.Replies, 
				'YourLastPost' = tpth.LastUserPostID,
				'YourLastPostIndex' = te2.PostIndex,
				fo.SiteID, 
				tpth.Private,
				tpth.CountPosts, 
				tpth.LastPostCountRead, 
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
				tpth.Type,
				tpth.EventDate,
				'DateFirstPosted' = te.DatePosted, 
				CASE WHEN (so.SiteID IS NULL AND fo.SiteID<>@siteid) THEN 0 ELSE 1 END AS 'IsPostingFromVisibleSite'
		-- NOTE: 1 is added to TOP to tell DNA there is more results, if there is indeed more
		FROM (SELECT TOP (@maxresults+1) tp.ThreadID, tp.LastPosting, tp.LastUserPosting, tp.LastUserPostID, tp.ForumID, 
					tp.Replies,
					tp.CountPosts,
					tp.LastPostCountRead,
					th.FirstSubject,
					'Private' = CASE WHEN th.CanRead = 0 THEN 1 ELSE 0 END,
					th.Type, th.EventDate
				FROM threadpostings tp WITH(NOLOCK)
				INNER JOIN Threads th WITH(NOLOCK) ON th.threadid = tp.threadid AND th.VisibleTo IS NULL
				WHERE tp.userid=@userid
				ORDER BY tp.LastPosting DESC) AS tpth
				
		INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
		INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.ThreadID = tpth.ThreadID AND te.PostIndex = 0
		INNER JOIN Users u2 WITH(NOLOCK) ON te.UserID = u2.UserID
		INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = tpth.ForumID
		LEFT JOIN SiteOptions so ON so.SiteID= fo.SiteID AND so.Section = 'General' AND so.Name = 'SiteIsPrivate' AND so.value='0' AND @IncludeContentFromOtherSites = 1 -- i.e. All public sites if current site includes content from other sites. 
		LEFT JOIN Users u1 WITH(NOLOCK) ON fo.JournalOwner = u1.UserID
		LEFT JOIN Preferences P WITH(NOLOCK) on (P.UserID = U.UserID) and (P.SiteID = fo.SiteID)
		LEFT JOIN Preferences P2 WITH(NOLOCK) on (P2.UserID = U2.UserID) and (P2.SiteID = fo.SiteID)
		INNER JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
		INNER JOIN SignInUserIDMapping siuidm2 WITH(NOLOCK) ON u2.UserID = siuidm2.DnaUserID
		--INNER JOIN dbo.Journals J1 WITH(NOLOCK) on J1.UserID = U.UserID and J1.SiteID = fo.SiteID
		INNER JOIN dbo.Journals J2 WITH(NOLOCK) on J2.UserID = U2.UserID and J2.SiteID = fo.SiteID
		LEFT JOIN dbo.ThreadEntries te2 WITH(NOLOCK) ON te2.EntryID = tpth.LastUserPostID
		ORDER BY LastReply DESC
