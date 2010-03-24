CREATE PROCEDURE getclubsinhierarchynode @nodeid INT, @currentsiteid INT
AS
BEGIN
		DECLARE @iCount INT
		SELECT @iCount = COUNT(*)
		FROM HierarchyClubMembers h WITH(NOLOCK)
		INNER JOIN Clubs c WITH(NOLOCK) ON c.ClubID = h.ClubID
		INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = c.h2g2id/10 AND g.status!=7 AND g.Hidden IS NULL
		WHERE h.nodeid = @nodeid
		
		SELECT  
			"count" = @iCount, 
			c.ClubID, 
			c.Name, 
			g.ExtraInfo, 
			'DateCreated' = ISNULL(c.DateCreated,g.DateCreated),	--If c.LastUpdated IS NULL c.LastUpdated > g.LastUpdated evaluates to false.
			--'LastUpdated' =  CASE WHEN c.LastUpdated > g.LastUpdated THEN c.LastUpdated ELSE g.LastUpdated END,
			'ClubForumLastUpdated' = journallastupdated.LastUpdated,
			'LastUpdated' = g.LastUpdated,
			'ClubLastUpdated' = c.LastUpdated, 
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
		INNER JOIN dbo.GuideEntries AS g WITH(NOLOCK) ON g.EntryID = c.h2g2id/10 AND g.status!=7 AND g.Hidden IS NULL
		INNER JOIN dbo.Teammembers AS tm WITH(NOLOCK) ON tm.teamid = c.ownerteam
		INNER JOIN dbo.USERS AS u WITH(NOLOCK) ON u.userid = tm.userid
		LEFT JOIN dbo.Preferences AS p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID= @currentsiteid
		INNER JOIN dbo.Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
		
		LEFT JOIN (
			select forumid, MAX(lastupdated) 'lastupdated' FROM forumlastupdated  f GROUP BY forumid
		) AS journallastupdated ON journallastupdated.forumid = c.journal
		
		WHERE h.nodeid = @nodeid 
		ORDER BY c.clubid ASC
		RETURN (0)
END
