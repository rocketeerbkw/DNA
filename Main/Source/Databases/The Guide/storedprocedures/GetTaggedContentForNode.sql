CREATE PROCEDURE gettaggedcontentfornode @maxrows INT, @nodeid INT, @siteid INT
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
	DECLARE @baseline INT;
	SELECT @baseline=baseline FROM dbo.Hierarchy WHERE NodeID=@nodeid;
 
	WITH CloseNodes AS
	(
		-- Just get parent nodes when baseline >=100
		SELECT h.NodeId FROM dbo.Hierarchy h
			WHERE parentid = @nodeid AND (ClubMembers > 0 OR ArticleMembers > 0)
				AND @baseline >=100

		UNION
		--- Get nodes for parent, children, indirect parents, baseline and indirect parents baseline

		-- Children
		SELECT h.NodeId FROM dbo.Hierarchy h, dbo.Hierarchy h1
			WHERE h.NodeId = h1.parentid AND h1.NodeId = @nodeid AND
				(h.ClubMembers > 0 OR h.ArticleMembers > 0)
				AND @baseline < 100

		UNION

		-- Parents
		SELECT h.NodeId FROM dbo.Hierarchy h
			WHERE parentid = @nodeid AND (ClubMembers > 0 OR ArticleMembers > 0) 
				AND @baseline < 100

		UNION

		-- Baseline
		SELECT h.NodeId FROM ancestors a, dbo.Hierarchy h
			WHERE a.NodeId = @nodeid AND h.baseline = 100 AND a.ancestorid = h.NodeId
				AND (h.ClubMembers > 0 OR h.ArticleMembers > 0)
				AND @baseline < 100

		UNION

		--indirect parent
		SELECT h.NodeId FROM dbo.Hierarchy h, dbo.Hierarchynodealias hna
			WHERE h.NodeId = hna.NodeId AND hna.LinkNodeId = @nodeid
				AND (ClubMembers > 0 OR ArticleMembers > 0)
				AND @baseline < 100

		UNION

		--indirect parent baseline
		SELECT h.NodeId FROM hierarchy h, dbo.Hierarchynodealias hna, dbo.Ancestors a, dbo.Hierarchy h1
			WHERE h1.NodeId = hna.NodeId AND hna.LinkNodeId = @nodeid
				AND (h.ClubMembers > 0 OR h.ArticleMembers > 0) AND a.NodeId = h1.NodeId 
				AND a.AncestorId = h.NodeId AND h.baseline = 100 
				AND @baseline < 100
	)
	SELECT TOP(@maxrows)
		'club' source, 
		g.h2g2ID, 
		g.Subject, 
		g.ExtraInfo, 
		g.type, 
		g.editor, 
		g.status, 
		(SELECT MAX(LastUpdated) FROM ForumLastUpdated ff WHERE ff.ForumId = c.Journal) as ClubForumLastUpdated ,
		'LastUpdated' = g.LastUpdated,
		'ClubLastUpdated' = c.LastUpdated, 
		'DateCreated' = ISNULL(c.DateCreated,g.DateCreated),
		c.ClubID, 
		c.Name, 
		u.UserName AS editorName,
		u.FIRSTNAMES AS EditorFirstNames, 
		u.LASTNAME AS EditorLastName, 
		u.AREA AS EditorArea, 
		u.STATUS AS EditorStatus, 
		u.TAXONOMYNODE AS EditorTaxonomyNode, 
		J1.ForumID AS EditorJournal, 
		u.ACTIVE AS EditorActive,
		p.SITESUFFIX AS EditorSiteSuffix, 
		P.TITLE AS EditorTitle,

		u2.UserID AS ClubOwnerUserID,
		u2.UserName AS ClubOwnerUserName,
		u2.FIRSTNAMES AS ClubOwnerFirstNames, 
		u2.LASTNAME AS ClubOwnerLastName, 
		u2.AREA AS ClubOwnerArea, 
		u2.STATUS AS ClubOwnerStatus, 
		u2.TAXONOMYNODE AS ClubOwnerTaxonomyNode, 
		J2.ForumID AS ClubOwnerJournal, 
		u2.ACTIVE AS ClubOwnerActive,
		p2.SITESUFFIX AS ClubOwnerSiteSuffix, 
		p2.TITLE AS ClubOwnerTitle   

	FROM dbo.Clubs AS c 
	INNER JOIN dbo.GuideEntries g on g.h2g2ID = c.h2g2ID
	LEFT JOIN dbo.Users u ON u.UserId = g.editor
	LEFT JOIN dbo.Preferences p ON p.UserID = u.UserID AND p.SiteID= @siteid

	INNER JOIN dbo.Teammembers AS tm ON tm.teamid = c.ownerteam
	INNER JOIN dbo.USERS AS u2 ON u2.userid = tm.userid
	LEFT JOIN dbo.Preferences AS p2 ON p2.UserID = u2.UserID AND p2.SiteID= @siteid
	INNER JOIN dbo.Journals J1 on J1.UserID = U.UserID and J1.SiteID = @siteid
	INNER JOIN dbo.Journals J2 on J2.UserID = U2.UserID and J2.SiteID = @siteid

	WHERE g.status != 7  AND c.ClubID IN 
	(
		SELECT h.ClubID  
			FROM CloseNodes AS cn
			INNER JOIN dbo.HierarchyClubMembers h ON  h.NodeID = cn.NodeID
	)     

	UNION ALL

	SELECT TOP(@maxrows)
		'article' source, 
		g.h2g2ID, 
		g.Subject, 
		g.ExtraInfo, 
		g.type, 
		g.editor,
		g.status, 
		'ClubForumLastUpdated' = NULL,
		'LastUpdated' = g.LastUpdated,
		'ClubLastUpdated' = NULL, 
		g.DateCreated, 
		ClubID = 0, 
		Name = '', 
		u.UserName AS editorName,
		u.FIRSTNAMES AS EditorFirstNames, 
		u.LASTNAME AS EditorLastName, 
		u.AREA AS EditorArea, 
		u.STATUS AS EditorStatus, 
		u.TAXONOMYNODE AS EditorTaxonomyNode, 
		J1.ForumID AS EditorJournal, 
		u.ACTIVE AS EditorActive,
		p.SITESUFFIX AS EditorSiteSuffix, 
		p.TITLE AS EditorTitle,

		ClubOwnerUserID = 0,
		ClubOwnerUserName = '',
		ClubOwnerFirstNames = '', 
		ClubOwnerLastName = '', 
		ClubOwnerArea = '', 
		ClubOwnerStatus = 0, 
		ClubOwnerTaxonomyNode = 0, 
		ClubOwnerJournal = 0, 
		ClubOwnerActive = 0,
		ClubOwnerSiteSuffix = '', 
		ClubOwnerTitle = ''   

	FROM dbo.GuideEntries AS g
	LEFT JOIN dbo.Users AS u ON u.UserId = g.editor
	LEFT JOIN dbo.Preferences AS p ON p.UserID = u.UserID AND p.SiteID= @siteid
	INNER JOIN dbo.Journals J1 on J1.UserID = U.UserID and J1.SiteID = @siteid
	WHERE g.status != 7 AND  g.EntryID IN 
	(
		SELECT h.EntryID 
			FROM CloseNodes AS cn
			INNER JOIN dbo.HierarchyArticleMembers AS h ON  h.NodeID = cn.NodeID
	) 
	 
	ORDER BY g.LastUpdated, ClubID DESC
END
