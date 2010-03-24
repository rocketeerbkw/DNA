CREATE PROCEDURE getemailalertstats @siteid int
AS
-- Get the correct values for the different content type
DECLARE @NodeType int, @ArticleType int, @ClubType int, @ForumType int, @ThreadType int, @PostType int, @UserType int, @VoteType int, @LinkType int, @TeamType int, @URLType int, @ClubMemberType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
EXEC SetItemTypeValInternal 'IT_H2G2', @ArticleType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT
EXEC SetItemTypeValInternal 'IT_POST', @PostType OUTPUT
EXEC SetItemTypeValInternal 'IT_USER', @UserType OUTPUT
EXEC SetItemTypeValInternal 'IT_VOTE', @VoteType OUTPUT
EXEC SetItemTypeValInternal 'IT_LINK', @LinkType OUTPUT
EXEC SetItemTypeValInternal 'IT_TEAM', @TeamType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB_MEMBERS', @ClubMemberType OUTPUT
EXEC SetItemTypeValInternal 'IT_URL', @URLType OUTPUT

IF (@siteid > 0)
BEGIN
	SELECT 'ItemType' = 'NoOfUserWithAlerts', COUNT(*) 'count', SiteID FROM dbo.EMailAlertList WITH(NOLOCK) WHERE SiteID = @SiteID GROUP BY SiteID
	UNION ALL

		SELECT 'ItemType' = 'NoOfItemsWithAlertsSet', 'count' = COUNT(DISTINCT alm.ItemID), eal.SiteID FROM dbo.EMailAlertListMembers alm WITH(NOLOCK)
			INNER JOIN dbo.EmailAlertList eal WITH(NOLOCK) ON eal.EmailAlertListID = alm.EmailAlertListID AND eal.SiteID = @SiteID
				GROUP BY eal.SiteID

	UNION ALL

		-- Select number of alerts with private delivery
		SELECT 'ItemType' = CASE WHEN alm.NotifyType = 1 THEN 'NoOfEmailAlertItems'
					WHEN alm.NotifyType = 2 THEN 'NoOfPvtMagAlertItems'
					WHEN alm.NotifyType = 3 THEN 'NoOfDisabledAlerts' END,
					COUNT(*) 'count', eal.SiteID FROM dbo.EmailAlertListMembers alm WITH(NOLOCK)
			INNER JOIN dbo.EmailAlertList eal WITH(NOLOCK) ON eal.EmailAlertListID = alm.EmailAlertListID AND eal.SiteID = @SiteID
				GROUP BY alm.NotifyType, eal.SiteID


	UNION ALL

	SELECT Counts.* FROM 
	(
		-- Total number of alerts on each content type per site
		SELECT TOP 1000 'ItemType' = CASE
			WHEN alm.ItemType = @NodeType THEN 'Nodes'
			WHEN alm.ItemType = @ArticleType THEN 'Articles'
			WHEN alm.ItemType = @ClubType THEN 'Clubs'
			WHEN alm.ItemType = @ForumType THEN 'Forums'
			WHEN alm.ItemType = @ThreadType THEN 'Threads'
			WHEN alm.ItemType = @PostType THEN 'Posts'
			WHEN alm.ItemType = @UserType THEN 'Users'
			WHEN alm.ItemType = @VoteType THEN 'Votes'
			WHEN alm.ItemType = @LinkType THEN 'Links'
			WHEN alm.ItemType = @TeamType THEN 'TeamMembers'
			WHEN alm.ItemType = @ClubMemberType THEN 'ClubMembers'
			WHEN alm.ItemType = @URLType THEN 'URLs'
			ELSE 'NotKnown' END,
			COUNT(*) 'Count',
			eal.SiteID
			FROM dbo.EmailAlertListMembers alm WITH(NOLOCK)
			INNER JOIN EMailAlertList eal WITH(NOLOCK) ON eal.EMailALertListID = alm.EmailAlertListID
			WHERE eal.SiteID = @SiteID
			GROUP BY alm.ItemType, eal.SiteID
			ORDER BY eal.SiteID
		) AS Counts
END
ELSE
BEGIN
	-- Total number of alerts on each content type per site
	SELECT 'ItemType' = CASE
		WHEN alm.ItemType = @NodeType THEN 'Nodes'
		WHEN alm.ItemType = @ArticleType THEN 'Articles'
		WHEN alm.ItemType = @ClubType THEN 'Clubs'
		WHEN alm.ItemType = @ForumType THEN 'Forums'
		WHEN alm.ItemType = @ThreadType THEN 'Threads'
		WHEN alm.ItemType = @PostType THEN 'Posts'
		WHEN alm.ItemType = @UserType THEN 'Users'
		WHEN alm.ItemType = @VoteType THEN 'Votes'
		WHEN alm.ItemType = @LinkType THEN 'Links'
		WHEN alm.ItemType = @TeamType THEN 'TeamMembers'
		WHEN alm.ItemType = @ClubMemberType THEN 'ClubMembers'
		WHEN alm.ItemType = @URLType THEN 'URLs'
		ELSE 'NotKnown' END,
		COUNT(*) 'Count',
		'SiteID' = 0
		FROM dbo.EmailAlertListMembers alm WITH(NOLOCK)
		GROUP BY alm.ItemType
		
	UNION ALL
	
	SELECT 'ItemType' = 'NoOfUserWithAlerts', COUNT(*) 'count', 'SiteID' = 0 FROM dbo.EMailAlertList WITH(NOLOCK)
	
	UNION ALL
	
	SELECT 'ItemType' = 'NoOfItemsWithAlertsSet', 'count' = COUNT(DISTINCT alm.ItemID), 'SiteID' = 0 FROM dbo.EMailAlertListMembers alm WITH(NOLOCK)
	
	UNION ALL
	
	SELECT 'ItemType' = CASE 
				WHEN alm.NotifyType = 1 THEN 'NoOfEmailAlertItems'
				WHEN alm.NotifyType = 2 THEN 'NoOfPvtMagAlertItems'
				WHEN alm.NotifyType = 3 THEN 'NoOfDisabledAlerts' END,
				COUNT(*) 'count',
				'SiteID' = 0
			FROM dbo.EmailAlertListMembers alm WITH(NOLOCK)
			GROUP BY alm.NotifyType
	
END
