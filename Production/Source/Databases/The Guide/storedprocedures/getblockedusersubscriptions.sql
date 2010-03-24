CREATE PROCEDURE getblockedusersubscriptions @userid INT, @siteid INT, @skip INT = 0, @show INT = 20
AS
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		@userid 'BlockerID', 
		u1.UserName 'BlockerUserName',
		u1.FirstNames 'BlockerFirstNames',
		u1.LastName 'BlockerLastName',
		u1.Status 'BlockerStatus',
		u1.Active 'BlockerActive',
		u1.Postcode 'BlockerPostcode',
		u1.Area 'BlockerArea',
		u1.TaxonomyNode 'BlockerTaxonomyNode',
		u1.UnreadPublicMessageCount 'BlockerUnreadPublicMessageCount',
		u1.UnreadPrivateMessageCount 'BlockerUnreadPrivateMessageCount',
		u1.Region 'BlockerRegion',
		u1.HideLocation 'BlockerHideLocation',
		u1.HideUserName 'BlockerHideUserName',
		u1.AcceptSubscriptions 'BlockerAcceptSubscriptions',
		ISNULL(csu1.Score, 0.0) AS 'BlockerZeitgeistScore'
	FROM dbo.Users u1
	LEFT JOIN dbo.ContentSignifUser csu1 WITH(NOLOCK) ON u1.Userid = csu1.Userid AND csu1.SiteID = @siteid
	WHERE u1.UserID = @userid ;
	
	--Second recordset containing the actual list of blocked users

	WITH CTE_USERLIST AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY bus.userid ASC) AS 'n', bus.userid
		FROM BlockedUserSubscriptions bus
		WHERE bus.authorID = @userid
	)
	SELECT 	u.UserId, 
			u.UserName, 
			u.FirstNames, 
			u.LastName, 
			u.Status, 
			u.TaxonomyNode, 
			u.Active, 
			csu.Score
	FROM CTE_USERLIST tmp WITH(NOLOCK)
	INNER JOIN dbo.Users u ON tmp.userid = u.userid
	LEFT JOIN dbo.ContentSignifUser csu ON u.Userid = csu.Userid AND csu.SiteID = @siteID
	WHERE n > @skip AND n <= @skip + @show

	RETURN @@ERROR