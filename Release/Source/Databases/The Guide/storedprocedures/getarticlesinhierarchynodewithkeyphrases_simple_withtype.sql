/*
	@nodeid - category node / hierarchy node
	@type - filter for article type
	@maxresults - max number of results to fetch.
	@currentsiteid - ?
*/
CREATE PROCEDURE getarticlesinhierarchynodewithkeyphrases_simple_withtype 	@nodeid INT, 
						@type  INT = 0, 
						@maxresults INT = 500, 
						@currentsiteid INT = 0
AS
BEGIN

	--String for representing query
	
		--Results filtered on type - get a count for inclusion in resultset.
		DECLARE @iActualRows int
		SELECT @iActualRows = COUNT(*)
			FROM HierarchyArticleMembers a WITH(NOLOCK)	
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
			WHERE a.nodeid = @nodeid AND g.Type  = @type

		CREATE TABLE #articles
		(
			TypeCount int,
			entryID int,
			h2g2ID int,
			Subject varchar(255),
			DateCreated datetime,
			LastUpdated datetime,
			ExtraInfo text,
			Status int,
			Editor int,
			Type int,
			editorName varchar(255),
			EditorFirstNames varchar(255), 
			EditorLastName varchar(255), 
			EditorArea varchar(100), 
			EditorStatus int, 
			EditorTaxonomyNode int, 
			EditorJournal int, 
			EditorActive bit,
			EditorSiteSuffix varchar(255), 
			EditorTitle varchar(255)	    
		)
			
		--Restrict number of rows to MaxResults
		INSERT INTO #articles
		SELECT TOP(@maxresults) 'TypeCount' = @iActualRows,
		g.entryID, 
		g.h2g2ID, 
		g.Subject, 
		g.DateCreated, 
		g.LastUpdated, 
		g.ExtraInfo, 
		g.Status, 
		g.Editor, 
		g.Type, 
		u.UserName 'editorName',
		U.FIRSTNAMES as EditorFirstNames, 
		U.LASTNAME as EditorLastName, 
		U.AREA as EditorArea, 
		U.STATUS as EditorStatus, 
		U.TAXONOMYNODE as EditorTaxonomyNode, 
		J.ForumID as EditorJournal, 
		U.ACTIVE as EditorActive,
		P.SITESUFFIX as EditorSiteSuffix, 
		P.TITLE as EditorTitle
		FROM HierarchyArticleMembers a WITH(NOLOCK)
		INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
		LEFT JOIN Users u WITH(NOLOCK) ON u.UserId = g.editor
		LEFT JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID = @currentsiteid
		LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
		WHERE a.nodeid = @nodeid AND g.Type  = @type
		ORDER BY g.DateCreated DESC
		
		--PRINT @SELECT
		--EXEC(@SELECT)							
	
		--First Result set of matching keyphrases
		SELECT art.EntryID, art.h2g2ID, kp.PhraseId, kp.phrase, ns.name as NameSpace, art.Type, art.DateCreated
		FROM #articles art 
			LEFT JOIN dbo.ArticleKeyPhrases akp WITH(NOLOCK) ON art.EntryID = akp.EntryID AND akp.siteid = @currentsiteid 
			LEFT JOIN [dbo].PhraseNameSpaces pns WITH(NOLOCK) ON akp.PhraseNamespaceID = pns.PhraseNameSpaceID
			LEFT JOIN [dbo].KeyPhrases kp WITH(NOLOCK) ON pns.PhraseID = kp.PhraseID
			LEFT JOIN [dbo].NameSpaces ns WITH(NOLOCK) ON pns.NameSpaceID = ns.NameSpaceID 
		WHERE pns.NameSpaceID IS NULL -- for the first step in namespace migration only 'old' phrases will be seleted i.e. those without a namespace		

		--Second Result set of the actual articles
		SELECT * FROM #articles 
END