CREATE PROCEDURE gettopfives2 @siteid int = 1, @groupname varchar(255) = NULL
AS
SELECT 
	TopFive.GroupName,
	TopFive.GroupDescription,
	TopFive.SiteID,
	TopFive.ForumID,
	TopFive.ThreadID,  
	TopFive.ClubID,
	TopFive.TopicID,
	'Title' = CASE WHEN TopFive.Title = '' THEN NULL ELSE TopFive.Title END,
	TopFive.Subject,
	TopFive.UserID,
	TopFive.EntryID,
	TopFive.h2g2ID,
	TopFive.Rank,
	TopFive.ActualID,
	TopFive.UserName,
	'FirstNames' = CASE WHEN TopFive.FirstNames = '' THEN NULL ELSE TopFive.FirstNames END,
	'LastName' = CASE WHEN TopFive.LastName = '' THEN NULL ELSE TopFive.LastName END,
	TopFive.NodeID,
	'Area' = CASE WHEN TopFive.Area = '' THEN NULL ELSE TopFive.Area END,
	TopFive.TaxonomyNode,
	'UserTitle' = CASE WHEN TopFive.UserTitle = '' THEN NULL ELSE TopFive.UserTitle END,
	'SiteSuffix' = CASE WHEN TopFive.SiteSuffix = '' THEN NULL ELSE TopFive.SiteSuffix END,
	TopFive.Status,
	TopFive.Journal,
	TopFive.Active,
	TopFive.ExtraInfo,
	TopFive.EventDate,
	TopFive.PostStyle,
	TopFive.PostId,
	TopFive.CommentId,
	TopFive.ItemAuthorID,
	TopFive.DateUpdated,
	'LinkItemType' = CASE WHEN TopFive.LinkItemType = '' THEN NULL ELSE TopFive.LinkItemType END,
	TopFive.LinkItemID,
	'LinkItemName' = CASE WHEN TopFive.LinkItemName = '' THEN NULL ELSE TopFive.LinkItemName END,
	TopFive.Type
FROM
(
	SELECT ArticleTopFives.* FROM
	(
		-- Do all the articles
		SELECT TOP 500
			tf.GroupName,
			tf.GroupDescription,
			tf.SiteID,
			tf.ForumID,
			tf.ThreadID,  
			tf.ClubID,
			tf.TopicID,
			'Title' = '',
			'Subject' = g.Subject,
			tf.UserID,
			'EntryID' = g.EntryID, 
			'h2g2ID' = g.h2g2ID, 	
			tf.Rank,
			'ActualID' = 'A' + CAST(g.h2g2ID AS varchar(40)),			
			'UserName' = u.UserName,
			'FirstNames' = u.FirstNames,
			'LastName' = u.LastName,
			tf.NodeID,
			'Area' = u.Area,
			'TaxonomyNode' = u.TaxonomyNode,
			'UserTitle' = p.Title,
			'SiteSuffix' = p.SiteSuffix,
			'Status' = NULL,
			'Journal' = NULL,
			'Active' = NULL,
			'ExtraInfo' = g.extraInfo, 
			'EventDate' = NULL,
			'PostStyle' = NULL,
			'PostId' = NULL,
			'CommentId' = NULL,
			'ItemAuthorID' = g.Editor,
			'DateUpdated' = g.LastUpdated,	
			'LinkItemType' = '',
			'LinkItemID' = NULL,
			'LinkItemName' = '',
			'Type' = g.Type
		FROM dbo.TopFives tf WITH(NOLOCK)
		INNER JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.h2g2ID = tf.h2g2id
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = g.Editor
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID = @SiteID
		WHERE tf.h2g2ID IS NOT NULL AND tf.SiteID = @SiteID AND (g.Hidden IS NULL OR g.Hidden = 0) AND (tf.GroupName = @groupname OR @groupname IS NULL)
		ORDER BY tf.GroupName, tf.Rank
	) AS ArticleTopFives

	UNION ALL

	SELECT NoticesEventAndDiaryTopFives.* FROM
	(
		-- Do Notices, Events and Campaign Diary Entries
		SELECT TOP 500
			tf.GroupName,
			tf.GroupDescription,
			tf.SiteID,
			tf.ForumID,
			tf.ThreadID,  
			tf.ClubID,
			tf.TopicID,
			'Title' = t.FirstSubject,
			'Subject' = te.Text,
			tf.UserID,
			'EntryID' = NULL,
			'h2g2ID' = NULL,
			tf.Rank,
			'ActualID' = '',
			'UserName' = u.UserName,
			'FirstNames' = u.FirstNames,
			'LastName' = u.LastName,
			tf.NodeID,
			'Area' = u.Area,
			'TaxonomyNode' = u.TaxonomyNode,
			'UserTitle' = p.Title,
			'SiteSuffix' = p.SiteSuffix,
			'Status' = ujournal.status,
			'Journal' = ujournal.Journal,
			'Active' = ujournal.Active,
			'ExtraInfo' = '', 
			'EventDate' = t.EventDate,
			'PostStyle' = te.PostStyle,
			'PostId' = te.EntryID,
			'CommentId' = te3.EntryID,
			'ItemAuthorID' = te.UserID,
			'DateUpdated' = t.LastUpdated,	
			'LinkItemType' = CASE WHEN tf.GroupName = 'MostRecentCampaignDiaryEntries' THEN 'Campaign' ELSE '' END,
			'LinkItemID' = CASE WHEN tf.GroupName = 'MostRecentCampaignDiaryEntries' THEN c.ClubID ELSE NULL END,
			'LinkItemName' = CASE WHEN tf.GroupName = 'MostRecentCampaignDiaryEntries' THEN c.Name ELSE '' END,
			'Type' = NULL
		FROM dbo.TopFives tf WITH(NOLOCK)
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = tf.ForumID
		INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = tf.ThreadID
		INNER JOIN dbo.ThreadEntries te WITH(NOLOCK) ON te.ThreadID = t.ThreadID AND te.PostIndex = 0 AND te.Hidden IS NULL
		INNER JOIN dbo.ThreadEntries te3 WITH(NOLOCK) ON te3.ThreadID = t.ThreadID AND te3.Hidden IS NULL AND te3.PostIndex = ( SELECT MAX(te2.PostIndex) FROM dbo.ThreadEntries te2 WITH(NOLOCK) WHERE te2.ThreadID = t.ThreadID AND te2.Hidden IS NULL )
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = te.UserID
		LEFT JOIN dbo.Clubs c WITH(NOLOCK) ON c.Journal = f.ForumID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID = @SiteID
		LEFT JOIN dbo.Users ujournal WITH(NOLOCK) ON ujournal.Journal = f.ForumID
		WHERE tf.SiteID = @SiteID AND tf.GroupName IN ('MostRecentEvents','MostRecentNotice','MostRecentCampaignDiaryEntries') AND (t.VisibleTo = 0 OR t.VisibleTo IS NULL) AND (tf.GroupName = @groupname OR @groupname IS NULL)
		ORDER BY tf.GroupName, tf.Rank
	) AS NoticesEventAndDiaryTopFives
	
	UNION ALL

	SELECT CommentsAndConversationsTopFives.* FROM
	(
		-- Do all conversations and comments	
		SELECT TOP 500
			tf.GroupName,
			tf.GroupDescription,
			tf.SiteID,
			tf.ForumID,
			tf.ThreadID,  
			tf.ClubID,
			tf.TopicID,
			'Title' = CASE WHEN t.FirstSubject = '' THEN 'No Subject' ELSE t.FirstSubject END,
			'Subject' = te.Text,
			tf.UserID,
			'EntryID' = NULL,
			'h2g2ID' = NULL,
			tf.Rank,
			'ActualID' = '',
			'UserName' = u.UserName,
			'FirstNames' = u.FirstNames,
			'LastName' = u.LastName,
			tf.NodeID,
			'Area' = u.Area,
			'TaxonomyNode' = u.TaxonomyNode,
			'UserTitle' = p.Title,
			'SiteSuffix' = p.SiteSuffix,
			'Status' = ujournal.status,
			'Journal' = ujournal.Journal,
			'Active' = ujournal.Active,
			'ExtraInfo' = '', 
			'EventDate' = t.EventDate,
			'PostStyle' = te.PostStyle,
			'PostId' = te.EntryID,
			'CommentId' = NULL,
			'ItemAuthorID' = te.UserID,
			'DateUpdated' = t.LastUpdated,	
			'LinkItemType' = CASE WHEN c.clubid IS NOT NULL THEN 'Campaign' ELSE dbo.udf_getguideentrytype(g.Type) END,
			'LinkItemID' = ISNULL(c.ClubID,g.h2g2ID),
			'LinkItemName' = ISNULL(c.Name,g.Subject),
			'Type' = NULL
		FROM dbo.TopFives tf WITH(NOLOCK)
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = tf.ForumID
		INNER JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = tf.ThreadID
		INNER JOIN dbo.ThreadEntries te WITH(NOLOCK) ON te.ThreadID = t.ThreadID AND te.Hidden IS NULL AND te.PostIndex = ( SELECT MAX(te2.PostIndex) FROM dbo.ThreadEntries te2 WITH(NOLOCK) WHERE te2.ThreadID = t.ThreadID AND te2.Hidden IS NULL )
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = te.UserID
		LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID = @SiteID
		LEFT JOIN dbo.Users ujournal WITH(NOLOCK) ON ujournal.Journal = f.ForumID
		LEFT JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = tf.ClubID
		LEFT JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.ForumID = tf.ForumID
		WHERE tf.SiteID = @SiteID AND tf.GroupName IN ('MostRecentComments','MostRecentConversations','PopularThreads') AND (t.VisibleTo = 0 OR t.VisibleTo IS NULL) AND (tf.GroupName = @groupname OR @groupname IS NULL)
			AND NOT EXISTS (SELECT * FROM guideentries g
							INNER JOIN topics tp ON tp.h2g2id=g.h2g2id
							WHERE g.forumid=f.forumid AND tp.topicStatus <> 0) -- This clause removes forums from preview topics
		ORDER BY tf.GroupName, tf.Rank
	) AS CommentsAndConversationsTopFives
	
	UNION ALL

	SELECT ClubTopFives.* FROM
	(
		-- Do updated clubs	
		SELECT TOP 500
			tf.GroupName,
			tf.GroupDescription,
			tf.SiteID,
			tf.ForumID,
			tf.ThreadID,  
			tf.ClubID,
			tf.TopicID,
			'Title' = c.Name,
			'Subject' = '',
			tf.UserID,
			'EntryID' = NULL,
			'h2g2ID' = NULL,
			tf.Rank,
			'ActualID' = '',
			'UserName' = '',
			'FirstNames' = '',
			'LastName' = '',
			tf.NodeID,
			'Area' = '',
			'TaxonomyNode' = NULL,
			'UserTitle' = '',
			'SiteSuffix' = NULL,
			'Status' = '',
			'Journal' = NULL,
			'Active' = NULL,
			'ExtraInfo' = '', 
			'EventDate' = NULL,
			'PostStyle' = NULL,
			'PostId' = NULL,
			'CommentId' = NULL,
			'ItemAuthorID' = NULL,
			'DateUpdated' = NULL,	
			'LinkItemType' = '',
			'LinkItemID' = NULL,
			'LinkItemName' = '',
			'Type' = NULL
		FROM dbo.TopFives tf WITH(NOLOCK)
		INNER JOIN dbo.Clubs c WITH(NOLOCK) ON c.ClubID = tf.ClubID
		INNER JOIN dbo.GuideEntries g WITH(NOLOCK) ON c.h2g2ID = g.h2g2ID
		WHERE tf.SiteID = @SiteID AND tf.ClubID IS NOT NULL AND tf.ForumID IS NULL AND (g.Hidden IS NULL OR g.Hidden = 0) AND (tf.GroupName = @groupname OR @groupname IS NULL)
		ORDER BY tf.GroupName, tf.Rank
	) AS ClubTopFives
	
	UNION ALL
	
	SELECT UserTopFives.* FROM
	(
		-- Do all Users
		SELECT TOP 500
			tf.GroupName,
			tf.GroupDescription,
			tf.SiteID,
			tf.ForumID,
			tf.ThreadID,  
			tf.ClubID,
			tf.TopicID,
			'Title' = '',
			'Subject' = '',
			tf.UserID,
			'EntryID' = NULL,
			'h2g2ID' = NULL,
			tf.Rank,
			'ActualID' = '',
			'UserName' = u.UserName,
			'FirstNames' = u.FirstNames,
			'LastName' = u.LastName,
			tf.NodeID,
			'Area' = u.Area,
			'TaxonomyNode' = u.TaxonomyNode,
			'UserTitle' = p.Title,
			'SiteSuffix' = p.SiteSuffix,
			'Status' = NULL,
			'Journal' = NULL,
			'Active' = NULL,
			'ExtraInfo' = '', 
			'EventDate' = NULL,
			'PostStyle' = NULL,
			'PostId' = NULL,
			'CommentId' = NULL,
			'ItemAuthorID' = NULL,
			'DateUpdated' = NULL,	
			'LinkItemType' = '',
			'LinkItemID' = NULL,
			'LinkItemName' = '',
			'Type' = NULL
		FROM dbo.TopFives tf WITH(NOLOCK)
		INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = tf.UserID
		INNER JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID = @SiteID
		WHERE tf.SiteID = @SiteID AND u.Status = 1 AND (tf.GroupName = @groupname OR @groupname IS NULL)
		ORDER BY tf.GroupName, tf.Rank
	) AS UserTopFIves
	
	UNION ALL

	SELECT ForumTopFives.* FROM
	(
		-- Do all forums	
		SELECT TOP 500
			tf.GroupName,
			tf.GroupDescription,
			tf.SiteID,
			tf.ForumID,
			tf.ThreadID,  
			tf.ClubID,
			tf.TopicID,
			'Title' = ISNULL(t.FirstSubject,f.Title),
			'Subject' = '',
			tf.UserID,
			'EntryID' = NULL,
			'h2g2ID' = NULL,
			tf.Rank,
			'ActualID' = '',
			'UserName' = '',
			'FirstNames' = '',
			'LastName' = '',
			tf.NodeID,
			'Area' = '',
			'TaxonomyNode' = NULL,
			'UserTitle' = '',
			'SiteSuffix' = NULL,
			'Status' = NULL,
			'Journal' = NULL,
			'Active' = NULL,
			'ExtraInfo' = '', 
			'EventDate' = NULL,
			'PostStyle' = NULL,
			'PostId' = NULL,
			'CommentId' = NULL,
			'ItemAuthorID' = NULL,
			'DateUpdated' = NULL,	
			'LinkItemType' = '',
			'LinkItemID' = NULL,
			'LinkItemName' = '',
			'Type' = NULL
		FROM dbo.TopFives tf WITH(NOLOCK)
		INNER JOIN dbo.Forums f WITH(NOLOCK) ON f.ForumID = tf.ForumID
		LEFT JOIN dbo.Threads t WITH(NOLOCK) ON t.ThreadID = tf.ThreadID
		WHERE tf.SiteID = @SiteID AND tf.ForumID IS NOT NULL AND tf.ThreadID IS NULL AND (tf.GroupName = @groupname OR @groupname IS NULL)
		ORDER BY tf.GroupName, tf.Rank
	) AS ForumTopFives
) AS TopFive
