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
CREATE PROCEDURE getarticlesinhierarchynodewithmediaassets_rating 	@nodeid INT, 
						@maxresults INT = 500, 
						@currentsiteid INT = 0
AS
BEGIN

	--String for representing query
	DECLARE @SELECT VARCHAR(8000)
	SET @SELECT = ''
	
	-- Set ContentRatingData fields and join tables
	declare @ContentRatingDataSelect varchar(100)
	declare @ContentRatingDataJoin varchar(200)

		set @ContentRatingDataSelect =	',pv.voteid CRPollID, pv.AverageRating CRAverageRating, pv.VoteCount CRVoteCount '
		set @ContentRatingDataJoin =	' left outer join PageVotes pv WITH(NOLOCK) on g.h2g2id=pv.itemid and pv.itemtype=1 ' +
		  			' left outer join Votes v WITH(NOLOCK) on pv.voteid=v.voteid and v.type=3 '
	
	
		--Get a balanced number of articles of each type
		DECLARE @CountVar int
		DECLARE @TypeVar  int
		
		--Use cursor to make a temp copy of the results -  only 1 row for each type concerned.
		DECLARE CountCursor CURSOR DYNAMIC for
		SELECT     g.Type, COUNT(*) 
		FROM HierarchyArticleMembers a WITH(NOLOCK)
		INNER JOIN GuideEntries g WITH(NOLOCK)
		ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
		WHERE a.nodeid = @nodeid
		GROUP BY Type
		ORDER BY COUNT(*) ASC

		OPEN CountCursor
		FETCH NEXT FROM CountCursor INTO @TypeVar, @CountVar

		--want concatenation of a string with null to yield string 
		DECLARE @fullquery VARCHAR(8000)
		SET @fullquery = ''
		DECLARE @iteration INT
		SET @iteration = 0
		
		--This parameter specifies how many of each type to fetch - an even distribution of each type up to MaxRows.
		DECLARE @allocation FLOAT
		DECLARE @unusedallocation FLOAT 
		DECLARE @unused INT
		SET @unused = 0
		SET @unusedallocation = 0
		
		--calc an allocation for each type. 
		SET @allocation = @maxresults
		IF @@CURSOR_ROWS > 0
		BEGIN
			SET @allocation = CAST(@maxresults AS FLOAT)/CAST(@@CURSOR_ROWS AS FLOAT)
		END
		
		CREATE TABLE #articles
		(
			TypeCount int,
			h2g2ID int,
			Subject varchar(255),
			DateCreated datetime,
			LastUpdated datetime,
			ExtraInfo text,
			Status int,
			Editor int,
			Type int,
			editorName varchar(255),
			CRPollID int, 
			CRAverageRating float, 
			CRVoteCount int,
			EditorFirstNames varchar(255), 
			EditorLastName varchar(255), 
			EditorArea varchar(100), 
			EditorStatus int, 
			EditorTaxonomyNode int, 
			EditorJournal int, 
			EditorActive bit,
			EditorSiteSuffix varchar(255), 
			EditorTitle varchar(255),
			MediaAssetID int, 	
			SiteID int,
			Caption varchar(255),
			Filename varchar(255),
			MimeType varchar(255),
			ContentType int,
			ExtraElementXML text,
			OwnerID int,
			MADateCreated datetime,
			MALastUpdated datetime,
			Description text,
			Hidden int,
			ExternalLinkURL varchar(255) 	    
		)


		--Do a select on each type, creating a union.
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
			--Concatenate string
			
			-- Distribute any unused alocation amongst remaining types.
			DECLARE @totalallocation INT
			SET @totalallocation = ROUND(@allocation + CAST(@unused AS FLOAT)/CAST((@@CURSOR_ROWS - @iteration) AS FLOAT),0)
				
			--Build up select string
			insert into #articles
			SELECT TOP(@totalallocation) 'TypeCount' = @CountVar,
				g.h2g2ID, g.Subject, g.DateCreated, g.LastUpdated, 
				g.ExtraInfo, g.Status, g.Editor, g.Type, u.UserName 'editorName'
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
				LEFT JOIN Preferences p WITH(NOLOCK) on p.UserID = u.UserID AND p.SiteID = @currentsiteid
				LEFT JOIN ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.EntryID = g.EntryID 
				LEFT JOIN MediaAsset MA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
				LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
				left outer join PageVotes pv WITH(NOLOCK) on g.h2g2id=pv.itemid and pv.itemtype=1
		  		left outer join Votes v WITH(NOLOCK) on pv.voteid=v.voteid and v.type=3 
				WHERE a.nodeid = @nodeid AND g.Type = @TypeVar
			
			
			IF ( (@allocation - @CountVar) > 0 )
			BEGIN
				--Add unused allocation / Redistribute any unused allocation amongst remaining types.
				SET @unused = @unused + @allocation - @CountVar
			END
			ELSE
			BEGIN
				--Reduce unused allocation.
				SET @unused = @unused - @totalallocation + @allocation
			END
			
			SET @ITERATION = @ITERATION + 1
			FETCH NEXT FROM CountCursor INTO @TypeVar, @CountVar
		END
			
		CLOSE CountCursor
		DEALLOCATE CountCursor
			
		--PRINT @fullquery	
		--EXECUTE(@fullquery)
		select * from #articles ORDER BY Type,DateCreated DESC
	
	RETURN(0)
END