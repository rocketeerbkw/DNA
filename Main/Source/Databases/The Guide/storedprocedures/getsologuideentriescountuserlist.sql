CREATE PROCEDURE getsologuideentriescountuserlist @skip int = 1, @show int = 50
as
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH CTE_SOLOGUIDEENTRIES as
	(	
		SELECT TOP (@skip + @show) ROW_NUMBER() OVER (ORDER BY count(s.entryid) DESC) AS Row, s.userid, count(s.entryid) 'Count'
		FROM
			(SELECT r.entryid,r.userid 
			FROM researchers r 
			INNER JOIN guideentries g on g.entryid=r.entryid and g.siteid=1 and g.type=1 and g.status=1 
			INNER JOIN researchers r2 on r2.entryid=r.entryid 
			WHERE r.userid <> g.editor 
			GROUP BY r.entryid,r.userid 
			HAVING count(*) <= 2) s 
		GROUP BY s.userid
		ORDER BY 'Count' Desc	
	)
	SELECT 
		'Total' = (select count(*) FROM CTE_SOLOGUIDEENTRIES), 
		tmp.UserID,
		tmp.Count, 
		u.FirstNames, 
		u.LastName, 
		u.Area,
		u.Status,
		u.TaxonomyNode,
		u.Active,
		'UserName' = CASE WHEN LTRIM(u.UserName) = '' THEN 'Researcher ' + CAST(u.UserID AS varchar) ELSE u.UserName END,
		siuidm.IdentityUserID 'IdentityUserID', 
		u.LoginName 'IdentityUserName', 
		u.UnreadPublicMessageCount,
		u.UnreadPrivateMessageCount,
		u.Region,
		u.HideLocation,
		u.HideUserName,
		1 'siteID'
	FROM CTE_SOLOGUIDEENTRIES tmp
		INNER JOIN Users u WITH(NOLOCK) ON tmp.UserID = u.UserID
		INNER JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
	WHERE Row > @skip AND Row <= @skip + @show
	ORDER BY Row

