/*
	Fetches a random article of the given status value, avoiding users
	homepages
	Useful for e.g. the random entry button
*/

create procedure fetchrandomarticle
	@siteid int,
	@status1 int,
	@status2 int = null,
	@status3 int = null,
	@status4 int = null,
	@status5 int = null
as

	;WITH CTE_RandomEntry AS
	(
		SELECT TOP 1 EntryID 
			FROM GuideEntries G WITH(NOLOCK)
			WHERE G.Type < 1001
				AND G.Hidden is null
				AND G.SiteID = @siteid
				AND G.Status in (@status1, @status2, @status3, @status4, @status5)
			ORDER BY RAND(checksum(newid()))

	)
	select cte.EntryID, 
			g.blobid, 
			g.DateCreated, 
			g.DateExpired, 
			g.Subject, 
			g.ForumID, 
			g.h2g2ID, 
			g.Editor, 
			g.Status,
			g.Style,
			g.Hidden,
			g.SiteID,
			g.Submittable,
			g.ExtraInfo,
			g.Type,
			g.LastUpdated,
			'IsMainArticle' = 1,
			g.text,
			g.ModerationStatus,
			g.PreProcessed,
			g.CanRead,
			g.CanWrite,
			g.CanChangePermissions,
			'EditorIdentityUserId'	= siuidm.IdentityUserID, 
			'EditorIdentityUserName'	= u.LoginName, 
			'EditorName'			= u.UserName, 
			'EditorFirstNames'		= u.FirstNames, 
			'EditorLastName'		= u.LastName, 
			'EditorArea'			= u.Area, 
			'EditorStatus'			= u.Status, 
			'EditorTaxonomyNode'	= u.TaxonomyNode, 
			'EditorJournal'			= J.ForumID, 
			'EditorActive'			= u.Active,
			'EditorTitle'			= p.Title,
			'EditorSiteSuffix'		= p.SiteSuffix
				
		FROM CTE_RandomEntry cte 
		INNER JOIN GuideEntries g WITH(NOLOCK) ON cte.EntryID = g.EntryID 
		INNER JOIN Users u WITH(NOLOCK) ON u.UserID = g.Editor
		LEFT JOIN SignInUserIDMapping siuidm WITH(NOLOCK) ON u.UserID = siuidm.DnaUserID
		LEFT JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID = @siteid
		INNER JOIN Journals J WITH(NOLOCK) ON J.UserID = u.UserID and J.SiteID = @siteid

return (0)
