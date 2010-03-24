CREATE PROCEDURE getuserpostingstats3 @userid int, @maxresults int, @siteid int
As

-- @maxresults is used to limit the number of results returned for popular values
-- NOTE: The TOP value is 1 more than the num results requested (e.g. TOP 26 for the "25" case)
--       This lets DNA know if there are more posts available
--
-- NOTE: If you change this SP, change related SP getalluserpostingstatsbasic.sql

		SELECT	tpth.ThreadID, tpth.FirstSubject, tpth.ForumID, 
				u.UserName,
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
				'SiteId' = @siteid, 
				tpth.Private,
				tpth.CountPosts, 
				tpth.LastPostCountRead, 
				'ForumTitle' = tpth.Title,
				'Journal' = u1.UserID, 
				'JournalName' = u1.UserName, 
				'JournalFirstNames' = u1.FirstNames,
				'JournalLastName' = u1.LastName, 
				'JournalArea' = u1.Area,
				'JournalTitle' = NULL,
				'JournalSiteSuffix' = NULL,
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
				tpth.Type,
				tpth.EventDate,
				'DateFirstPosted' = te.DatePosted
		-- NOTE: TOP is set to (25+1) to tell DNA there is more, if there is indeed more
		FROM (SELECT TOP (@maxresults+1) tp.ThreadID, tp.LastPosting, tp.LastUserPosting, tp.LastUserPostID, tp.ForumID, 
					tp.Replies,
					tp.CountPosts,
					tp.LastPostCountRead,
					th.FirstSubject,
					'Private' = CASE WHEN th.CanRead = 0 THEN 1 ELSE 0 END,
					th.Type, 
					th.EventDate,
					f.Title
				FROM threadpostings tp WITH(NOLOCK)
				INNER JOIN Threads th WITH(NOLOCK) ON th.threadid = tp.threadid AND th.VisibleTo IS NULL
				INNER JOIN Forums f WITH (NOLOCK) ON f.forumid = th.forumid AND f.siteid = @siteid
				WHERE tp.userid=@userid
				ORDER BY tp.LastPosting DESC) AS tpth
				
		INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
		INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.ThreadID = tpth.ThreadID AND te.PostIndex = 0
		INNER JOIN Users u2 WITH(NOLOCK) ON te.UserID = u2.UserID
		INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = tpth.ForumID
		LEFT JOIN Users u1 WITH(NOLOCK) ON fo.JournalOwner = u1.UserID
		LEFT JOIN Preferences P WITH(NOLOCK) on (P.UserID = U.UserID) and (P.SiteID = fo.SiteID)
		LEFT JOIN Preferences P2 WITH(NOLOCK) on (P2.UserID = U2.UserID) and (P2.SiteID = fo.SiteID)
		--INNER JOIN dbo.Journals J1 WITH(NOLOCK) on J1.UserID = U.UserID and J1.SiteID = fo.SiteID
		INNER JOIN dbo.Journals J2 WITH(NOLOCK) on J2.UserID = U2.UserID and J2.SiteID = fo.SiteID
		ORDER BY LastReply DESC
