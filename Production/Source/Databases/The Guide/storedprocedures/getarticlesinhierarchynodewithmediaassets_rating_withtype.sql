/*
	@nodeid - category node / hierarchy node
	@type - filter for article type
	@maxresults - max number of results to fetch.
	@showcontentrating - adds content rating info to resultset.
	@currentsiteid - ?
	The idea of this stored procedure is to restrict the number of articles returned to maxresults 
	but also to balance the articltypes returned. 
	It attempts to pull out the same number of each article type but will allow any
	unused allocation to 'roll-over' to subsequent article types.
*/
CREATE PROCEDURE getarticlesinhierarchynodewithmediaassets_rating_withtype 	@nodeid INT, 
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
			
		--Restrict number of rows to MaxResults
		SELECT TOP(@maxresults) 'TypeCount' = @iActualRows
		, g.h2g2ID, g.Subject, g.DateCreated, g.LastUpdated, g.ExtraInfo, g.Status, g.Editor, g.Type, u.UserName 'editorName'
		,pv.voteid CRPollID, pv.AverageRating CRAverageRating, pv.VoteCount CRVoteCount 
		, U.FIRSTNAMES as EditorFirstNames, U.LASTNAME as EditorLastName, U.AREA as EditorArea, U.STATUS as EditorStatus, U.TAXONOMYNODE as EditorTaxonomyNode, J.ForumID as EditorJournal, U.ACTIVE as EditorActive,
		P.SITESUFFIX as EditorSiteSuffix, P.TITLE as EditorTitle, 
		AMA.MediaAssetID, 	
		MA.SiteID,
		MA.Caption,
		MA.Filename,
		MA.MimeType,
		MA.ContentType,
		MA.ExtraElementXML,
		MA.OwnerID,
		MA.DateCreated AS MADateCreated,
		MA.LastUpdated AS MALastUpdated,
		MA.Description,
		MA.Hidden,
		MA.ExternalLinkURL 	 
		FROM HierarchyArticleMembers a WITH(NOLOCK)
		INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
		LEFT JOIN Users u WITH(NOLOCK) ON u.UserId = g.editor
		LEFT JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID = @currentsiteid
		LEFT JOIN ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.EntryID = g.EntryID 
		LEFT JOIN MediaAsset MA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
		LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
		left outer join PageVotes pv WITH(NOLOCK) on g.h2g2id=pv.itemid and pv.itemtype=1
		left outer join Votes v WITH(NOLOCK) on pv.voteid=v.voteid and v.type=3 
		WHERE a.nodeid = @nodeid AND g.Type  = @type
		ORDER BY g.DateCreated DESC
		
		--PRINT @SELECT
		--EXEC(@SELECT)							
	
	RETURN(0)
END