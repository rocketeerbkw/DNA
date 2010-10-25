CREATE PROCEDURE getlinksubscriptionlist @userid INT, @siteid INT, @showprivate bit = 0, @skip int = 0, @show int = 20
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT 
		@userid , 
		u1.UserName,
		siuidm1.IdentityUserID 'IdentityUserID', 
		u1.LoginName 'IdentityUserName', 
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
		ISNULL(csu1.Score, 0.0) AS 'ZeitgeistScore',
		@siteid 'siteID'
	FROM dbo.Users u1
	LEFT JOIN dbo.ContentSignifUser csu1 WITH(NOLOCK) ON u1.Userid = csu1.Userid AND csu1.SiteID = @siteid
	INNER JOIN SignInUserIDMapping siuidm1 WITH(NOLOCK) ON u1.UserID = siuidm1.DnaUserID
	WHERE u1.UserID = @userid ;
	
	--Second recordset containing the actual list of Subscribed To users


	WITH CTE_LINKLIST AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY DateLinked DESC) AS 'n', l.LinkId
		FROM Links l
		INNER JOIN UserSubscriptions us ON us.authorId = l.SubmitterId
		INNER JOIN dbo.udf_GetVisibleSites(@siteid) vs ON l.DestinationSiteID = vs.SiteID
		WHERE l.relationship = 'bookmark' AND us.userId = @userid AND l.private IN (0,@showprivate)
	)
	SELECT links.*, 
			u.userid 'submitterid',
			siuidm.IdentityUserID 'submitterIdentityUserID', 
			u.LoginName 'submitterIdentityUserName', 
			u.username 'submitterusername',
			u.firstnames 'submitterfirstnames',
			u.lastname 'submitterlastname',
			u.status 'submitterstatus',
			u.taxonomynode 'submittertaxonomynode',
			u.active 'submitteractive',
			@siteid 'siteID'
	FROM CTE_LINKLIST tmp WITH(NOLOCK) 
	INNER JOIN Links links ON links.LinkId = tmp.LinkId
	INNER JOIN Users u ON u.userId = links.submitterId
	INNER JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
	WHERE tmp.n > @skip AND tmp.n <= @skip + @show
	ORDER BY n

END