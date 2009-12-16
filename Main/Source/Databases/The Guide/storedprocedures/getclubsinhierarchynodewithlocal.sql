CREATE PROCEDURE getclubsinhierarchynodewithlocal @nodeid INT, @usernodeid INT, @currentsiteid INT
AS
BEGIN

	SELECT 'nodeid' = a.nodeid INTO #UserLocalNodes
	FROM Ancestors a
	WHERE a.ancestorid = @usernodeid
	INSERT INTO #UserLocalNodes VALUES(@usernodeid)

	CREATE INDEX [IDX_ULN] ON #UserLocalNodes (nodeid)

	DECLARE @iCount INT
	SELECT @iCount = COUNT(*)
	FROM HierarchyClubMembers h WITH(NOLOCK)
	INNER JOIN Clubs c WITH(NOLOCK) ON c.ClubID = h.ClubID
	INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = c.h2g2id/10 AND g.status!=7 AND g.Hidden IS NULL
	WHERE h.nodeid = @nodeid

	SELECT	
		"count" = @iCount, 
		c.clubid,
		c.Name,
		g.ExtraInfo,
		'DateCreated' = ISNULL(c.DateCreated,g.DateCreated),
		--'LastUpdated' =  CASE WHEN c.LastUpdated > g.LastUpdated THEN c.LastUpdated ELSE g.LastUpdated END,
		'LastUpdated' = g.LastUpdated,
		'ClubLastUpdated' = c.LastUpdated,
		'ClubForumLastUpdated' = journallastupdated.LastUpdated,
		'Local' = CASE WHEN c2.clubid = c.clubid THEN 1 ELSE 0 END,	
			
		u.UserID AS ClubOwnerUserID,
		u.UserName AS ClubOwnerUserName,
		u.FIRSTNAMES AS ClubOwnerFirstNames, 
		u.LASTNAME AS ClubOwnerLastName, 
		u.AREA AS ClubOwnerArea, 
		u.STATUS AS ClubOwnerStatus, 
		u.TAXONOMYNODE AS ClubOwnerTaxonomyNode, 
		J.ForumID AS ClubOwnerJournal, 
		u.ACTIVE AS ClubOwnerActive,
		p.SITESUFFIX AS ClubOwnerSiteSuffix, 
		p.TITLE AS ClubOwnerTitle						
		
	FROM dbo.HierarchyClubMembers AS h WITH(NOLOCK) 
	INNER JOIN dbo.Clubs AS c WITH(NOLOCK) ON c.ClubID = h.ClubID
	INNER JOIN dbo.GuideEntries AS g WITH(NOLOCK) ON g.EntryID = c.h2g2id/10 AND g.status != 7 AND g.Hidden IS NULL
	LEFT JOIN dbo.Clubs AS c2 WITH(NOLOCK)  ON 
				(
					EXISTS 
						(
							SELECT hcm.nodeid 
							FROM dbo.HierarchyClubMembers AS hcm WITH(NOLOCK) 
							INNER JOIN #UserLocalNodes AS uln ON uln.nodeid = hcm.nodeid
							WHERE hcm.clubid = c2.clubid AND c2.clubid = c.clubid
						)
				)
				
	INNER JOIN dbo.Teammembers AS tm WITH(NOLOCK) ON tm.teamid = c.ownerteam
	INNER JOIN dbo.USERS AS u WITH(NOLOCK) ON u.userid = tm.userid
	LEFT JOIN dbo.Preferences AS p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID= @currentsiteid
	INNER JOIN dbo.Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
	LEFT JOIN (
		select forumid, MAX(lastupdated) 'lastupdated' FROM forumlastupdated  f GROUP BY forumid
	) AS journallastupdated ON journallastupdated.forumid = c.journal
			
	WHERE h.nodeid = @nodeid 

	DROP TABLE #UserLocalNodes
	
	RETURN (0)
END
