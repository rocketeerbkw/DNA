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
CREATE PROCEDURE getarticlesinhierarchynodewithlocal_usernode @nodeid INT, @maxresults INT = 500, 
	@usernodeid int, @currentsiteid int = 0
AS
BEGIN

	--String for representing query
	DECLARE @SELECT VARCHAR(8000)
	SET @SELECT = ''
	
	
	--when a non zero @usernodeid specified calculate if article is local
	if (@usernodeid > 0) begin
		--use a temporary table to hold all the nodea that are local to a user
		SELECT 'nodeid'=a.nodeid INTO #UserLocalNodes
		FROM Ancestors a WITH(NOLOCK)
		WHERE a.ancestorid = @usernodeid
		INSERT INTO #UserLocalNodes VALUES(@usernodeid)

		CREATE INDEX [IDX_ULN] ON #UserLocalNodes (nodeid)
		
		
	end 
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
			local int,
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
			--select 'alloc' = @totalallocation			

			insert into #articles	
			SELECT TOP(@totalallocation) 'TypeCount'= @CountVar, 
				g.h2g2ID, g.Subject, g.DateCreated, g.LastUpdated, 
				g.ExtraInfo, g.Status, g.Editor, g.Type, u.UserName 'editorName'
				, 'local' = case when g.h2g2id = g2.h2g2id then 1 else 0 end 
				, 	U.FIRSTNAMES as EditorFirstNames, U.LASTNAME as EditorLastName, U.AREA as EditorArea, U.STATUS as EditorStatus, U.TAXONOMYNODE as EditorTaxonomyNode, J.ForumID as EditorJournal, U.ACTIVE as EditorActive,
				P.SITESUFFIX as EditorSiteSuffix, P.TITLE as EditorTitle
			FROM HierarchyArticleMembers a WITH(NOLOCK) 
			INNER JOIN GuideEntries g WITH(NOLOCK) ON g.EntryID = a.EntryID AND g.status != 7 AND g.Hidden IS NULL
			LEFT JOIN Users u WITH(NOLOCK) ON u.UserId = g.editor
			LEFT JOIN Preferences p WITH(NOLOCK) ON p.UserId = u.UserID AND p.SiteID = @currentsiteid
			LEFT JOIN Journals J WITH(NOLOCK) on J.UserID = U.UserID and J.SiteID = @currentsiteid
			left join GuideEntries g2 WITH(NOLOCK) on 
					(EXISTS (select ham.nodeid from HierarchyArticleMembers ham WITH(NOLOCK)
								inner join #UserLocalNodes uln on uln.nodeid = ham.nodeid
								where ham.EntryID = g2.EntryID and g2.EntryID = g.EntryID  AND g.Type=@TypeVar ))
			WHERE a.nodeid = @nodeid AND g.Type=@TypeVar 


				
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
			FETCH NEXT FROM CountCursor INTO @TypeVar, @CountVar
		END
			
		
		CLOSE CountCursor
		DEALLOCATE CountCursor
		
		select * from #articles ORDER BY Type,DateCreated DESC
		drop table #articles
			
	--delete the temporary table if required
	if (@usernodeid > 0) begin
		DROP TABLE #UserLocalNodes
	end
	
	RETURN(0)
END






