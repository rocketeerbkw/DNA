/*
	@nodeid - category node / hierarchy node
	@type - filter for article type
	@maxresults - max number of results to fetch.
	@showcontentrating - adds content rating info to resultset.
	@usernodeid - local user node/location node
	@currentsiteid - ?
	This stored procedure is a special case of getarticlesinhierarchynode with the additional feature of 
	being able to identify if an article is local to user. If this is modified then also propogate the change into
	getarticlesinhierarchy node.
	The idea of this stored procedure is to restrict the number of articles returned to maxresults 
	but also to balance the articltypes returned. 
	It attempts to pull out the same number of each article type but will allow any
	unused allocation to 'roll-over' to subsequent article types.
*/
CREATE PROCEDURE getarticlesinhierarchynodewithlocal_simple_withtype @nodeid INT, @type  INT, @maxresults INT = 500, 
	@currentsiteid int = 0
AS
BEGIN

		--Results filtered on type - get a count for inclusion in resultset.
		DECLARE @iActualRows int
		SELECT @iActualRows = COUNT(*)
			FROM HierarchyArticleMembers a WITH(NOLOCK)	
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7
			WHERE a.nodeid = @nodeid AND g.Type  = @type
			  AND g.Hidden IS NULL

			
			
		--Restrict number of rows to MaxResults
		SELECT TOP (@maxresults) 'TypeCount' = @iActualRows
		, g.h2g2ID, g.Subject, g.DateCreated, g.LastUpdated, g.ExtraInfo, g.Status, g.Editor, g.Type, u.UserName 'editorName'
		, 	U.FIRSTNAMES as EditorFirstNames, U.LASTNAME as EditorLastName, U.AREA as EditorArea, U.STATUS as EditorStatus, U.TAXONOMYNODE as EditorTaxonomyNode, J.ForumID as EditorJournal, U.ACTIVE as EditorActive,
		P.SITESUFFIX as EditorSiteSuffix, P.TITLE as EditorTitle
		FROM HierarchyArticleMembers a WITH(NOLOCK)
		INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
		LEFT JOIN Users u WITH(NOLOCK) ON u.UserId = g.editor
		LEFT JOIN Preferences p WITH(NOLOCK) ON p.UserId = u.UserID AND p.SiteID= @currentsiteid 
		LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
		WHERE a.nodeid = @nodeid AND g.Type  = @type
		ORDER BY g.DateCreated DESC
		
	
	RETURN(0)
END






