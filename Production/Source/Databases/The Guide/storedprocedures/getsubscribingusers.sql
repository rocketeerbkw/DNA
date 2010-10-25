create procedure getsubscribingusers @userid int, @siteid int, @skip int, @show int
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		@userid 'SubscribedToID', 
		siuidm1.IdentityUserID 'SubscribedToIdentityUserID', 
		u1.LoginName 'SubscribedToIdentityUserName', 
		u1.UserName 'SubscribedToUserName',
		u1.FirstNames 'SubscribedToFirstNames',
		u1.LastName 'SubscribedToLastName',
		u1.Status 'SubscribedToStatus',
		u1.Active 'SubscribedToActive',
		u1.Postcode 'SubscribedToPostcode',
		u1.Area 'SubscribedToArea',
		u1.TaxonomyNode 'SubscribedToTaxonomyNode',
		u1.UnreadPublicMessageCount 'SubscribedToUnreadPublicMessageCount',
		u1.UnreadPrivateMessageCount 'SubscribedToUnreadPrivateMessageCount',
		u1.Region 'SubscribedToRegion',
		u1.HideLocation 'SubscribedToHideLocation',
		u1.HideUserName 'SubscribedToHideUserName',
		u1.AcceptSubscriptions 'SubscribedToAcceptSubscriptions',
		ISNULL(csu1.Score, 0.0) AS 'SubscribedToZeitgeistScore',
		@siteid 'siteID'
	FROM dbo.Users u1
	LEFT JOIN dbo.ContentSignifUser csu1 WITH(NOLOCK) ON u1.Userid = csu1.Userid AND csu1.SiteID = @siteid
	INNER JOIN SignInUserIDMapping siuidm1 WITH(NOLOCK) ON u1.UserID = siuidm1.DnaUserID
	WHERE u1.UserID = @userid ;
	
	--Second recordset containing the actual list of subscribing users

	WITH CTE_USERLIST AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY us.UserID ASC) AS 'n', us.UserID
		FROM UserSubscriptions us
		WHERE us.AuthorID = @userid
	)
	SELECT
	tmp.UserID,
	siuidm.IdentityUserID, 
	'IdentityUserName' = u.LoginName, 
	u.UserName,
	u.FirstNames,
	u.LastName,
	u.Status,
	u.Active,
	u.Postcode,
	u.Area,
	u.TaxonomyNode,
	u.UnreadPublicMessageCount,
	u.UnreadPrivateMessageCount,
	u.Region,
	u.HideLocation,
	u.HideUserName,
	u.AcceptSubscriptions,
	ISNULL(csu.Score, 0.0) AS 'ZeitgeistScore',
	@siteid 'siteID'
	FROM CTE_USERLIST tmp WITH(NOLOCK) 
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = tmp.UserID
	LEFT JOIN dbo.ContentSignifUser csu WITH(NOLOCK) ON u.Userid = csu.Userid AND csu.SiteID = @siteid
	INNER JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
	WHERE n > @skip AND n <= @skip + @show
	ORDER BY n
