CREATE PROCEDURE getuserssubscriptionlist @userid int, @siteid int, @skip int = 0, @show int = 20
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		@userid 'SubscriberID', 
		u1.UserName 'SubscriberUserName',
		u1.FirstNames 'SubscriberFirstNames',
		u1.LastName 'SubscriberLastName',
		u1.Status 'SubscriberStatus',
		u1.Active 'SubscriberActive',
		u1.Postcode 'SubscriberPostcode',
		u1.Area 'SubscriberArea',
		u1.TaxonomyNode 'SubscriberTaxonomyNode',
		u1.UnreadPublicMessageCount 'SubscriberUnreadPublicMessageCount',
		u1.UnreadPrivateMessageCount 'SubscriberUnreadPrivateMessageCount',
		u1.Region 'SubscriberRegion',
		u1.HideLocation 'SubscriberHideLocation',
		u1.HideUserName 'SubscriberHideUserName',
		u1.AcceptSubscriptions 'SubscriberAcceptSubscriptions',
		ISNULL(csu1.Score, 0.0) AS 'SubscriberZeitgeistScore'
	FROM dbo.Users u1
	LEFT JOIN dbo.ContentSignifUser csu1 WITH(NOLOCK) ON u1.Userid = csu1.Userid AND csu1.SiteID = @siteid
	WHERE u1.UserID = @userid ;
	
	--Second recordset containing the actual list of Subscribed To users


	WITH CTE_USERLIST AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY us.AuthorID ASC) AS 'n', us.AuthorID
		FROM UserSubscriptions us
		WHERE us.UserID = @userid
	)
	SELECT 
	tmp.AuthorID AS 'subscribedToID',
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
	ISNULL(csu.Score, 0.0) AS 'ZeitgeistScore'
	FROM CTE_USERLIST tmp WITH(NOLOCK) 
	INNER JOIN dbo.Users u  WITH(NOLOCK) ON u.UserID = tmp.AuthorID
	LEFT JOIN dbo.ContentSignifUser csu  WITH(NOLOCK) ON u.Userid = csu.Userid AND csu.SiteID = @siteid
	WHERE n > @skip AND n <= @skip + @show
	ORDER BY n

END