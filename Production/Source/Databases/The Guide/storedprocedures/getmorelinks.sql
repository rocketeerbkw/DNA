create procedure getmorelinks @userid int, @linkgroup varchar(255), @showprivate int, @siteid int, @skip int = 0, @show int = 21 
as
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		@userid , 
		u1.UserName,
		u1.FirstNames,
		u1.LastName,
		u1.Status,
		u1.Active,
		u1.Postcode,
		u1.Area,
		u1.TaxonomyNode,
		u1.UnreadPublicMessageCount,
		u1.UnreadPrivateMessageCount ,
		u1.Region,
		u1.HideLocation,
		u1.HideUserName,
		u1.AcceptSubscriptions,
		ISNULL(csu1.Score, 0.0) AS 'ZeitgeistScore'
	FROM dbo.Users u1
	LEFT JOIN dbo.ContentSignifUser csu1 WITH(NOLOCK) ON u1.Userid = csu1.Userid AND csu1.SiteID = @siteid
	WHERE u1.UserID = @userid ;

	WITH CTE_LINKLIST AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY DateLinked DESC) AS 'n', l.LinkId
		FROM Links l
		INNER JOIN dbo.udf_GetVisibleSites(@siteid) vs ON l.DestinationSiteID = vs.SiteID
		WHERE l.relationship = 'bookmark' AND l.submitterId = @userid AND l.private IN (0,@showprivate)
	)
	SELECT links.*, 
			u.userid 'submitterid',
			u.username 'submitterusername',
			u.firstnames 'submitterfirstnames',
			u.lastname 'submitterlastname',
			u.status 'submitterstatus',
			u.taxonomynode 'submittertaxonomynode',
			u.active 'submitteractive'
	FROM CTE_LINKLIST tmp WITH(NOLOCK) 
	INNER JOIN Links links ON links.LinkId = tmp.LinkId
	INNER JOIN Users u ON u.userId = links.submitterId
	WHERE tmp.n > @skip AND tmp.n <= @skip + @show
	ORDER BY n

END