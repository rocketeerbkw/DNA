CREATE PROCEDURE gettaggedcontent @maxrows INT, @sort INT, 
	@hierarchynodes VARCHAR (6000),
	@currentsiteid INT = 0
AS
BEGIN
	SET ROWCOUNT @maxRows
	
			SELECT
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
			
			FROM dbo.Clubs AS c WITH(NOLOCK) 
			INNER JOIN dbo.GuideEntries g WITH(NOLOCK) on g.h2g2ID = c.h2g2ID
			LEFT JOIN dbo.Users u WITH(NOLOCK) ON u.UserId = g.editor
			LEFT JOIN dbo.Preferences p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID= @currentsiteid
			
			INNER JOIN dbo.Teammembers AS tm WITH(NOLOCK) ON tm.teamid = c.ownerteam
			INNER JOIN dbo.USERS AS u2 WITH(NOLOCK) ON u2.userid = tm.userid
			LEFT JOIN dbo.Preferences AS p2 WITH(NOLOCK) ON p2.UserID = u2.UserID AND p2.SiteID= @currentsiteid
			INNER JOIN dbo.Journals J1 with(nolock) on J1.UserID = U.UserID and J1.SiteID = @currentsiteid
			INNER JOIN dbo.Journals J2 with(nolock) on J2.UserID = U2.UserID and J2.SiteID = @currentsiteid
			
			WHERE g.status != 7  AND c.ClubID IN 
					(
						SELECT h.ClubID  
						FROM udf_splitvarchar(@hierarchynodes) AS s
						INNER JOIN dbo.HierarchyClubMembers h WITH(NOLOCK) ON  h.NodeID = s.element
					) 				
		
		UNION ALL
				
			SELECT
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
			
			FROM dbo.GuideEntries AS g WITH(NOLOCK)
			LEFT JOIN dbo.Users AS u WITH(NOLOCK) ON u.UserId = g.editor
			LEFT JOIN dbo.Preferences AS p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID= @currentsiteid
			INNER JOIN dbo.Journals J1 with(nolock) on J1.UserID = U.UserID and J1.SiteID = @currentsiteid
			WHERE g.status != 7 AND  g.EntryID IN 
					(
						SELECT h.EntryID 
						FROM udf_splitvarchar(@hierarchynodes) AS s
						INNER JOIN dbo.HierarchyArticleMembers AS h WITH(NOLOCK) ON  h.NodeID = s.element
					) 
					
	ORDER BY g.LastUpdated, ClubID DESC

	SET ROWCOUNT 0
	
END
		
RETURN(0)