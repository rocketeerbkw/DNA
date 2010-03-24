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
CREATE PROCEDURE getarticlesinhierarchynode 	@nodeid INT, 
						@type  INT = 0, 
						@maxresults INT = 500, 
						@showcontentratingdata int = 0, 
						@currentsiteid INT = 0
AS
BEGIN

	--String for representing query
	DECLARE @SELECT VARCHAR(8000)
	SET @SELECT = ''
	
	-- Set ContentRatingData fields and join tables
	declare @ContentRatingDataSelect varchar(100)
	declare @ContentRatingDataJoin varchar(200)

	if(@showcontentratingdata = 1) begin
		set @ContentRatingDataSelect =	',pv.voteid CRPollID, pv.AverageRating CRAverageRating, pv.VoteCount CRVoteCount '
		set @ContentRatingDataJoin =	' left outer join PageVotes pv WITH(NOLOCK) on g.h2g2id=pv.itemid and pv.itemtype=1 ' +
		  			' left outer join Votes v WITH(NOLOCK) on pv.voteid=v.voteid and v.type=3 '
	end else begin
		set @ContentRatingDataSelect = ' '
		set @ContentRatingDataJoin = ' '
	end
	
	
	IF @type = 0
	BEGIN	
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

		--Do a select on each type, creating a union.
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
			--Concatenate string
			If @iteration > 0
			BEGIN
				SET @SELECT = ' 
						UNION ALL
						'
			END
			
			-- Distribute any unused alocation amongst remaining types.
			DECLARE @totalallocation INT
			SET @totalallocation = ROUND(@allocation + CAST(@unused AS FLOAT)/CAST((@@CURSOR_ROWS - @iteration) AS FLOAT),0)
				
			--Build up select string
			SET @SELECT = @SELECT + 'SELECT TOP ' + CAST(@totalallocation AS VARCHAR) + ' ''TypeCount''=' + 
				CAST(@CountVar AS VARCHAR) + ' ,g.h2g2ID, g.Subject, g.DateCreated, g.LastUpdated, 
				g.ExtraInfo, g.Status, g.Editor, g.Type, u.UserName ''editorName''' +
				@ContentRatingDataSelect + 
				', U.FIRSTNAMES as EditorFirstNames, U.LASTNAME as EditorLastName, U.AREA as EditorArea, U.STATUS as EditorStatus, U.TAXONOMYNODE as EditorTaxonomyNode, J.ForumID as EditorJournal, U.ACTIVE as EditorActive,
				P.SITESUFFIX as EditorSiteSuffix, P.TITLE as EditorTitle 
			FROM HierarchyArticleMembers a WITH(NOLOCK) 
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
			LEFT JOIN Users u WITH(NOLOCK) ON u.UserId = g.editor
			LEFT JOIN Preferences p WITH(NOLOCK) on p.UserID = u.UserID AND p.SiteID = ' + CAST(@currentsiteid AS VARCHAR) + 
			' LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = u.UserID and J.SiteID = ' + CAST(@currentsiteid AS VARCHAR) +
			@ContentRatingDataJoin +
			'WHERE a.nodeid = ' + CAST(@nodeid AS VARCHAR) + ' AND g.Type=' + CAST(@TypeVar AS VARCHAR)
			
			IF LEN(@fullquery) + LEN(@SELECT ) >= 7999
				BREAK
			
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
			SET @fullquery = @fullquery +  @SELECT
			FETCH NEXT FROM CountCursor INTO @TypeVar, @CountVar
		END
			
		IF ( LEN(@fullquery) > 0 )
		BEGIN
			SET @fullquery = @fullquery + ' ORDER BY g.Type,g.DateCreated DESC'
		END
		
		CLOSE CountCursor
		DEALLOCATE CountCursor
			
		--PRINT @fullquery	
		EXECUTE(@fullquery)
	END
	ELSE
	BEGIN	
		--Results filtered on type - get a count for inclusion in resultset.
		DECLARE @iActualRows int
		SELECT @iActualRows = COUNT(*)
			FROM HierarchyArticleMembers a WITH(NOLOCK)	
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
			WHERE a.nodeid = @nodeid AND g.Type  = @type
			
		--Restrict number of rows to MaxResults
		SET @SELECT = 'SELECT TOP ' + CAST(@maxresults AS VARCHAR) +  ' ''TypeCount'' =' +  CAST(@iActualRows AS VARCHAR) + 
		', g.h2g2ID, g.Subject, g.DateCreated, g.LastUpdated, g.ExtraInfo, g.Status, g.Editor, g.Type, u.UserName ''editorName''' +
		@ContentRatingDataSelect +
		', U.FIRSTNAMES as EditorFirstNames, U.LASTNAME as EditorLastName, U.AREA as EditorArea, U.STATUS as EditorStatus, U.TAXONOMYNODE as EditorTaxonomyNode, J.ForumID as EditorJournal, U.ACTIVE as EditorActive,
		P.SITESUFFIX as EditorSiteSuffix, P.TITLE as EditorTitle 
		FROM HierarchyArticleMembers a WITH(NOLOCK)
		INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
		LEFT JOIN Users u WITH(NOLOCK) ON u.UserId = g.editor
		LEFT JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID AND p.SiteID = ' + CAST(@currentsiteid AS VARCHAR) + 
		' LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = u.UserID and J.SiteID = ' + CAST(@currentsiteid AS VARCHAR) +
		@ContentRatingDataJoin +
		'WHERE a.nodeid = ' + CAST(@nodeid AS VARCHAR) + ' AND g.Type  = ' + CAST(@type AS VARCHAR) + 
		' ORDER BY g.DateCreated DESC'
		
		--PRINT @SELECT
		EXEC(@SELECT)							
	END
	
	RETURN(0)
END