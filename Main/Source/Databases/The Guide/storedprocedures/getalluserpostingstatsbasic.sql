CREATE PROCEDURE getalluserpostingstatsbasic @userid int, @maxresults int, @siteid int
As

-- This is the same as getalluserpostingstats3, but with placeholders for some of the data for sites that don't need it

-- @maxresults is used to limit the number of results returned for popular values
-- NOTE: The TOP value is 1 more than the num results requested (e.g. TOP 26 for the "25" case)
--       This lets DNA know if there are more posts available
--
-- NOTE: If you change this SP, change related SP getalluserpostingstats3.sql

		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		-- Check if site includes content from other sites
		DECLARE @IncludeContentFromOtherSites INT
		SELECT @IncludeContentFromOtherSites = dbo.udf_getsiteoptionsetting(@siteid, 'PersonalSpace', 'IncludeContentFromOtherSites');

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
				fo.SiteID, 
				tpth.Private,
				tpth.CountPosts, 
				tpth.LastPostCountRead, 
				'ForumTitle' = fo.Title,
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
				null as DateFirstPosted, 
				CASE WHEN (so.SiteID IS NULL AND fo.SiteID<>@siteid) THEN 0 ELSE 1 END AS 'IsPostingFromVisibleSite'
		-- NOTE: 1 is added to TOP to tell DNA there is more results, if there is indeed more
		FROM (SELECT TOP (@maxresults + 1) tp.ThreadID, tp.LastPosting, tp.LastUserPosting, tp.LastUserPostID, tp.ForumID, 
					tp.Replies,
					tp.CountPosts,
					tp.LastPostCountRead,
					th.FirstSubject,
					'Private' = CASE WHEN th.CanRead = 0 THEN 1 ELSE 0 END,
					th.Type, th.EventDate
				FROM threadpostings tp WITH(NOLOCK)
				INNER JOIN Threads th WITH(NOLOCK) ON th.threadid = tp.threadid AND th.VisibleTo IS NULL
				WHERE tp.userid=@userid
				ORDER BY tp.LastPosting DESC) as tpth

		INNER JOIN Users u WITH(NOLOCK) ON u.UserID = @userid
		INNER JOIN ThreadEntries te WITH(NOLOCK) ON te.ThreadID = tpth.ThreadID AND te.PostIndex = 0
		INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = tpth.ForumID
		LEFT JOIN SiteOptions so ON so.SiteID= fo.SiteID AND so.Section = 'General' AND so.Name = 'SiteIsPrivate' AND so.value='0' AND @IncludeContentFromOtherSites = 1 -- i.e. All public sites if current site includes content from other sites. 
		ORDER BY LastReply DESC