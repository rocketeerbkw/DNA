CREATE PROCEDURE getuserpostingstatsbasic @userid int, @maxresults int, @siteid int
As

-- This is the same as getalluserpostingstats3, but with placeholders for some of the data for sites that don't need it

-- @maxresults is used to limit the number of results returned for popular values
-- NOTE: The TOP value is 1 more than the num results requested (e.g. TOP 26 for the "25" case)
--       This lets DNA know if there are more posts available
--
-- NOTE: If you change this SP, change related SP getalluserpostingstats3.sql

IF @maxresults <= 25
BEGIN
		SELECT	tpth.ThreadID, tpth.FirstSubject, tpth.ForumID, 
				u.UserName,
				null as Area,
				null as FirstNames,
				null as LastName,
				null as Status,
				null as TaxonomyNode,
				null as UserJournal,
				null as Active,
				null as Title,
				null as SiteSuffix,
				'MostRecent' = tpth.LastUserPosting,
				'LastReply' = tpth.LastPosting, 
				tpth.Replies, 
				'YourLastPost' = tpth.LastUserPostID,
				'SiteId' = @siteid, 
				tpth.Private,
				tpth.CountPosts, 
				tpth.LastPostCountRead, 
				--'ForumTitle' = fo.Title,
				'ForumTitle' = tpth.Title,
				null as Journal,
				null as JournalName,
				null as JournalFirstNames,
				null as JournalLastName,
				null as 'JournalArea',
				null as 'JournalTitle',
				null as 'JournalSiteSuffix',
				null as FirstPosterUserID, 
				null as FirstPosterUsername,
				null as FirstPosterFirstNames,
				null as FirstPosterLastName,
				null as FirstPosterArea,
				null as FirstPosterStatus,
				null as FirstPosterTaxonomyNode,
				null as FirstPosterJournal,
				null as FirstPosterActive,
				null as FirstPosterTitle,
				null as FirstPosterSiteSuffix,
				tpth.Type,
				tpth.EventDate,
				null as DateFirstPosted
		-- NOTE: TOP is set to (25+1) to tell DNA there is more, if there is indeed more
		FROM (SELECT TOP 26 tp.ThreadID, tp.LastPosting, tp.LastUserPosting, tp.LastUserPostID, tp.ForumID, 
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
				ORDER BY tp.LastPosting DESC) as tpth

		INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
		INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.ThreadID = tpth.ThreadID AND te.PostIndex = 0
		--INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = tpth.ForumID
		ORDER BY LastReply DESC
END
ELSE IF @maxresults <= 50
BEGIN
		SELECT	tpth.ThreadID, tpth.FirstSubject, tpth.ForumID, 
				u.UserName,
				null as Area,
				null as FirstNames,
				null as LastName,
				null as Status,
				null as TaxonomyNode,
				null as UserJournal,
				null as Active,
				null as Title,
				null as SiteSuffix,
				'MostRecent' = tpth.LastUserPosting,
				'LastReply' = tpth.LastPosting, 
				tpth.Replies, 
				'YourLastPost' = tpth.LastUserPostID,
				'SiteId' = @siteid, 
				tpth.Private,
				tpth.CountPosts, 
				tpth.LastPostCountRead, 
				'ForumTitle' = tpth.Title,
				null as Journal,
				null as JournalName,
				null as JournalFirstNames,
				null as JournalLastName,
				null as 'JournalArea',
				null as 'JournalTitle',
				null as 'JournalSiteSuffix',
				null as FirstPosterUserID, 
				null as FirstPosterUsername,
				null as FirstPosterFirstNames,
				null as FirstPosterLastName,
				null as FirstPosterArea,
				null as FirstPosterStatus,
				null as FirstPosterTaxonomyNode,
				null as FirstPosterJournal,
				null as FirstPosterActive,
				null as FirstPosterTitle,
				null as FirstPosterSiteSuffix,
				tpth.Type,
				tpth.EventDate,
				null as DateFirstPosted
		-- NOTE: TOP is set to (50+1) to tell DNA there is more, if there is indeed more
		FROM (SELECT TOP 51 tp.ThreadID, tp.LastPosting, tp.LastUserPosting, tp.LastUserPostID, tp.ForumID, 
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
				ORDER BY tp.LastPosting DESC) as tpth

		INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
		INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.ThreadID = tpth.ThreadID AND te.PostIndex = 0
		--INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = tpth.ForumID
		ORDER BY LastReply DESC
END
ELSE
BEGIN
		SELECT	tpth.ThreadID, tpth.FirstSubject, tpth.ForumID, 
				u.UserName,
				null as Area,
				null as FirstNames,
				null as LastName,
				null as Status,
				null as TaxonomyNode,
				null as UserJournal,
				null as Active,
				null as Title,
				null as SiteSuffix,
				'MostRecent' = tpth.LastUserPosting,
				'LastReply' = tpth.LastPosting, 
				tpth.Replies, 
				'YourLastPost' = tpth.LastUserPostID,
				'SiteId' = @siteid, 
				tpth.Private,
				tpth.CountPosts, 
				tpth.LastPostCountRead, 
				'ForumTitle' = tpth.Title,
				null as Journal,
				null as JournalName,
				null as JournalFirstNames,
				null as JournalLastName,
				null as 'JournalArea',
				null as 'JournalTitle',
				null as 'JournalSiteSuffix',
				null as FirstPosterUserID, 
				null as FirstPosterUsername,
				null as FirstPosterFirstNames,
				null as FirstPosterLastName,
				null as FirstPosterArea,
				null as FirstPosterStatus,
				null as FirstPosterTaxonomyNode,
				null as FirstPosterJournal,
				null as FirstPosterActive,
				null as FirstPosterTitle,
				null as FirstPosterSiteSuffix,
				tpth.Type,
				tpth.EventDate,
				null as DateFirstPosted
		-- NOTE: This TOP value is an arbitrary limit, to prevent the SP taking too much time in the default case
		FROM (SELECT TOP 400 tp.ThreadID, tp.LastPosting, tp.LastUserPosting, tp.LastUserPostID, tp.ForumID, 
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
				ORDER BY tp.LastPosting DESC) as tpth

		INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
		INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.ThreadID = tpth.ThreadID AND te.PostIndex = 0
		--INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = tpth.ForumID
		ORDER BY LastReply DESC
END