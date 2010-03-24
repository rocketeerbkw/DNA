CREATE PROCEDURE getmoreroutes @userid int, @siteid int, @skip INT = 0, @show INT = 20
AS
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		@userid, 
		u1.UserName,
		u1.FirstNames,
		u1.LastName,
		u1.Status,
		u1.Active,
		u1.Postcode,
		u1.Area,
		u1.TaxonomyNode,
		u1.UnreadPublicMessageCount,
		u1.UnreadPrivateMessageCount,
		u1.Region,
		u1.HideLocation,
		u1.HideUserName,
		u1.AcceptSubscriptions,
		ISNULL(csu1.Score, 0.0) AS 'ZeitgeistScore'
	FROM dbo.Users u1
	LEFT JOIN dbo.ContentSignifUser csu1 WITH(NOLOCK) ON u1.Userid = csu1.Userid AND csu1.SiteID = @siteid
	WHERE u1.UserID = @userid;
	
	--Second recordset containing the actual list of the users routes

	WITH CTE_USERSROUTELIST AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY route.routeid ASC) AS 'n', route.RouteID
		FROM Route route
		WHERE route.userid = @userid
	)
	SELECT 	tmp.RouteID,
			route.UserId, 
			route.EntryID,
			g.H2G2ID,
			g.Subject,
			route.Approved,
			route.DateCreated,
			route.Title As 'RouteTitle',
			route.Description As 'RouteDescription',
			route.SiteID
	FROM CTE_USERSROUTELIST tmp WITH(NOLOCK)
	INNER JOIN dbo.Route route ON tmp.RouteID = route.RouteID
	LEFT JOIN dbo.GuideEntries g ON g.EntryID = route.EntryID
	WHERE n > @skip AND n <= @skip + @show

	RETURN @@ERROR