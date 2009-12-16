CREATE Procedure getalluserpostingstats2 @userid int
As
--		SELECT c.Cnt, c.ThreadID, t.FirstSubject, t.ForumID, u.UserName, c.MostRecent, c1.LastReply, 'Replies' = CASE WHEN c.MostRecent >= c1.LastReply THEN 0 ELSE 1 END, c.YourLastPost
--		FROM Threads t
--		INNER JOIN (SELECT 'Cnt' = COUNT (*), 'YourLastPost' = MAX(EntryID), 'Min' = MIN(DatePosted), ThreadID, 'MostRecent' = MAX(DatePosted) FROM ThreadEntries
--		WHERE UserID = @userid AND (Hidden <> 1 OR Hidden IS NULL)
--		GROUP BY ThreadID) AS c ON c.ThreadID = t.ThreadID
--		INNER JOIN (SELECT ThreadID, 'LastReply' = MAX(DatePosted) FROM ThreadEntries
--		/* WHERE DatePosted > @after AND DatePosted < @before */
--		GROUP BY ThreadID) AS c1 ON c1.ThreadID = t.ThreadID
--		INNER JOIN Users u ON u.UserID = @userid
--		ORDER BY /* Replies DESC, */ c1.LastReply DESC

		SELECT	t.ThreadID, f.FirstSubject, t.ForumID, 
				u.UserName,
				u.Area,
				u.FirstNames,
				u.LastName,
				u.Status,
				u.TaxonomyNode,
				--'UserJournal' = J1.ForumID, -- Never used, and impossible to infer without an input siteID
				u.Active,
				P.Title,
				P.SiteSuffix,
				'MostRecent' = t.LastUserPosting,
				'LastReply' = t.LastPosting, t.Replies, 'YourLastPost' = t.LastUserPostID,
				fo.SiteID, 'Private' = CASE WHEN f.CanRead = 0 THEN 1 ELSE 0 END,
				/*t.Private,*/ t.CountPosts, t.LastPostCountRead, 'ForumTitle' = fo.Title,
				'Journal' = u1.UserID, 'JournalName' = u1.UserName, 'JournalFirstNames' = u1.FirstNames,
				'JournalLastName' = u1.LastName, 'JournalArea' = u1.Area,
				'JournalTitle' = NULL /*P1.Title*/, 'JournalSiteSuffix' = NULL /*P1.SiteSuffix*/,
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
				'DateFirstPosted' = te.DatePosted
		FROM ThreadPostings t WITH(NOLOCK) --,INDEX=IX_ThreadPostings)
		INNER JOIN Threads f WITH(NOLOCK) 
			ON f.ThreadID = t.ThreadID
		INNER JOIN Users u WITH(NOLOCK) 
			ON u.UserID = t.UserID 
		INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.ThreadID = t.ThreadID AND te.PostIndex = 0
		INNER JOIN Users u2 WITH(NOLOCK) ON te.UserID = u2.UserID
		INNER JOIN Forums fo WITH(NOLOCK) 
			ON fo.ForumID = t.ForumID
		LEFT JOIN Users u1 WITH(NOLOCK) ON fo.JournalOwner = u1.UserID
		LEFT JOIN Preferences P WITH(NOLOCK) on (P.UserID = U.UserID) and (P.SiteID = fo.SiteID)
		--LEFT JOIN Preferences P1 WITH(NOLOCK) on (P1.UserID = U1.UserID) and (P1.SiteID = fo.SiteID)
		LEFT JOIN Preferences P2 WITH(NOLOCK) on (P2.UserID = U2.UserID) and (P2.SiteID = fo.SiteID)
		--INNER JOIN dbo.Journals J1 WITH(NOLOCK) on J1.UserID = U.UserID and J1.SiteID = fo.SiteID
		INNER JOIN dbo.Journals J2 WITH(NOLOCK) on J2.UserID = U2.UserID and J2.SiteID = fo.SiteID
		WHERE t.UserID = @userid AND f.VisibleTo IS NULL
		ORDER BY LastReply DESC

