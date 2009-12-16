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
CREATE PROCEDURE getarticlesinhierarchynodewithlocalwithmediaassets @nodeid INT, @type  INT = 0, @maxresults INT = 500, 
	@showcontentratingdata int = 0, @usernodeid int = 0, @currentsiteid int = 0
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
	
	declare @LocalMemberDataSelect varchar(100)
	declare @LocalMemberDataJoin varchar(400)
	
	--when a non zero @usernodeid specified calculate if article is local
	if (@usernodeid > 0) begin
		--use a temporary table to hold all the nodea that are local to a user
		SELECT 'nodeid'=a.nodeid INTO #UserLocalNodes
		FROM Ancestors a WITH(NOLOCK)
		WHERE a.ancestorid = @usernodeid
		INSERT INTO #UserLocalNodes VALUES(@usernodeid)

		CREATE INDEX [IDX_ULN] ON #UserLocalNodes (nodeid)
		
		set @LocalMemberDataSelect = ', ''local'' = case when g.h2g2id = g2.h2g2id then 1 else 0 end '
		
	end else begin
		set @LocalMemberDataSelect = ''
		set @LocalMemberDataJoin = ''
	end
	
	
	IF @type = 0
	BEGIN	
		--Get a balanced number of articles of each type
		DECLARE @CountVar int
		DECLARE @TypeVar  int

		--Use cursor to make a temp copy of the results -  only 1 row for each type concerned.
		DECLARE CountCursor INSENSITIVE CURSOR for
		SELECT     g.Type, COUNT(*) 
		FROM HierarchyArticleMembers a WITH(NOLOCK)
		INNER JOIN GuideEntries g  WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
		WHERE a.nodeid = @nodeid
		GROUP BY Type
		ORDER BY COUNT(*) ASC


		OPEN CountCursor
		FETCH NEXT FROM CountCursor INTO @TypeVar, @CountVar

		--want concatenation of a string with null to yield string 
		DECLARE @fullquery VARCHAR(8000)
		SET @fullquery = ''
		
		DECLARE @iteration int
		DECLARE @allocation FLOAT
		DECLARE @unusedallocation FLOAT 
		DECLARE @unused INT
		SET @iteration = 0
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
			If @ITERATION > 0
			BEGIN
				SET @SELECT = ' 
						UNION ALL
						'
			END
			
			-- Distribute any unused alocation amongst remaining types.
			DECLARE @totalallocation INT
			SET @totalallocation = ROUND(@allocation + CAST(@unused AS FLOAT)/CAST((@@CURSOR_ROWS - @iteration) AS FLOAT),0)
			
			if (@usernodeid > 0) begin
				set @LocalMemberDataJoin = ' left join GuideEntries g2 WITH(NOLOCK) on 
					(EXISTS (select ham.nodeid from HierarchyArticleMembers ham WITH(NOLOCK)
								inner join #UserLocalNodes uln on uln.nodeid = ham.nodeid
								where ham.EntryID = g2.EntryID and g2.EntryID = g.EntryID  AND g.Type=' 
								+ CAST(@TypeVar AS VARCHAR) + ' )) '
			end	
				
			--Build up select string
			SET @SELECT = @SELECT + 'SELECT TOP ' + CAST(@totalallocation AS VARCHAR) + ' ''TypeCount''=' + 
				CAST(@CountVar AS VARCHAR) + ' ,g.h2g2ID, g.Subject, g.DateCreated, g.LastUpdated, 
				g.ExtraInfo, g.Status, g.Editor, g.Type, u.UserName ''editorName''' +
				@ContentRatingDataSelect + @LocalMemberDataSelect +
				', 	U.FIRSTNAMES as EditorFirstNames, U.LASTNAME as EditorLastName, U.AREA as EditorArea, U.STATUS as EditorStatus, U.TAXONOMYNODE as EditorTaxonomyNode, J.ForumID as EditorJournal, U.ACTIVE as EditorActive,
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
				LEFT JOIN Preferences p WITH(NOLOCK) ON p.UserId = u.UserID AND p.SiteID = ' + CAST(@currentsiteid AS VARCHAR) + ' 
				LEFT JOIN ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.EntryID = g.EntryID 
				LEFT JOIN MediaAsset MA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID ' +
				' LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = ' + CAST(@currentsiteid AS VARCHAR) + ' ' +
				@LocalMemberDataJoin +
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
			
			SET @iteration = @iteration + 1
			SET @fullquery = @fullquery +  @select
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
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7
			WHERE a.nodeid = @nodeid AND g.Type  = @type
			  AND g.Hidden IS NULL

		if (@usernodeid > 0) begin
			set @LocalMemberDataJoin = ' left join GuideEntries g2 WITH(NOLOCK) on 
				(EXISTS (select ham.nodeid from HierarchyArticleMembers ham WITH(NOLOCK)
							inner join #UserLocalNodes uln on uln.nodeid = ham.nodeid
							where ham.EntryID = g2.EntryID and g2.EntryID = g.EntryID  AND g.Type=' 
							+ CAST(@type AS VARCHAR) + ' )) '	
		end		
			
			
		--Restrict number of rows to MaxResults
		SET @SELECT = 'SELECT TOP ' + CAST(@maxresults AS VARCHAR) +  ' ''TypeCount'' =' +  CAST(@iActualRows AS VARCHAR) + 
		', g.h2g2ID, g.Subject, g.DateCreated, g.LastUpdated, g.ExtraInfo, g.Status, g.Editor, g.Type, u.UserName ''editorName''' +
		@ContentRatingDataSelect +
		@LocalMemberDataSelect +
		', 	U.FIRSTNAMES as EditorFirstNames, U.LASTNAME as EditorLastName, U.AREA as EditorArea, U.STATUS as EditorStatus, U.TAXONOMYNODE as EditorTaxonomyNode, J.ForumID as EditorJournal, U.ACTIVE as EditorActive,
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
		LEFT JOIN Preferences p WITH(NOLOCK) ON p.UserId = u.UserID AND p.SiteID='+ CAST(@currentsiteid AS VARCHAR) + ' 
		LEFT JOIN ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.EntryID = g.EntryID 
		LEFT JOIN MediaAsset MA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID ' +
		' LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = ' + CAST(@currentsiteid AS VARCHAR) + ' ' +
		@LocalMemberDataJoin +
		@ContentRatingDataJoin +
		'WHERE a.nodeid = ' + CAST(@nodeid AS VARCHAR) + ' AND g.Type  = ' + CAST(@type AS VARCHAR)  +
		' ORDER BY g.DateCreated DESC'
		
		--PRINT @SELECT
		
		EXEC(@SELECT)							
	END
	
	--delete the temporary table if required
	if (@usernodeid > 0) begin
		DROP TABLE #UserLocalNodes
	end
	
	RETURN(0)
END
