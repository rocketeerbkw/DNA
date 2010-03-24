CREATE PROCEDURE searcharticlesadvanced2 @keywords varchar(500),
					    @siteid int = 1,
					    @useandsearch int = 1,
					    @showsubmitted int = 1,
					    @showapproved int = 1,
					    @shownormal int = 1,
					    @withincategory int = NULL,
					    @maxresults int = 500
AS
-- Setup the category clause conditions
DECLARE @CategorySearch varchar(1000)
IF (@withincategory IS NULL)
BEGIN
	SET @CategorySearch = ''
END
ELSE
BEGIN
	SET @CategorySearch = 'AND G.EntryID IN ( SELECT m.EntryID FROM HierarchyArticleMembers m WITH(NOLOCK)
					WHERE m.NodeID = ' + CAST(@withincategory as varchar) + ' 
					OR m.NodeID IN (SELECT a.NodeID FROM Ancestors a WITH(NOLOCK) WHERE a.AncestorID = ' + CAST(@withincategory as varchar) + ')
					OR m.NodeID IN (SELECT l.LinkNodeID FROM HierarchyNodeAlias l WITH(NOLOCK) WHERE l.NodeID = ' + CAST(@withincategory as varchar) + ' 
					OR l.NodeID IN (SELECT a1.NodeID FROM Ancestors a1 WITH(NOLOCK) WHERE a1.AncestorID = ' + CAST(@withincategory as varchar) + ')))'
END
--PRINT (@CategorySearch)


-- Setup the search conditions
DECLARE @SearchCondition varchar(max)
DECLARE @Check int
SET @Check = PATINDEX('%,%',@keywords)
IF (@Check > 0)
BEGIN
	SET @SearchCondition = 'ISABOUT('
	SET @SearchCondition = @SearchCondition + '"' + REPLACE(@keywords, ',', ' ') + '" ' + 'WEIGHT(1.0), '
	SET @SearchCondition = @SearchCondition + '"' + REPLACE(@keywords, ',', '" NEAR "') + '" ' + 'WEIGHT(0.75), '
	SET @SearchCondition = @SearchCondition + '"' + REPLACE(@keywords, ',', '" WEIGHT(0.5), "') + '" WEIGHT(0.5), ' 
	SET @SearchCondition = @SearchCondition + 'FORMSOF(INFLECTIONAL,"' + REPLACE(@keywords, ',', '") WEIGHT(0.25), FORMSOF(INFLECTIONAL,"') + '") WEIGHT(0.25))'
END
ELSE
BEGIN
	SET @SearchCondition = 'ISABOUT("'+@keywords+'" WEIGHT(1.0), FORMSOF(INFLECTIONAL,"'+@keywords+'") WEIGHT(0.25))'
END
--PRINT (@SearchCondition)

-- Setup the AND Search Condition if needed
DECLARE @SubANDCondition varchar(1000)
DECLARE @TextANDCondition varchar(1000)
DECLARE @SafeSubANDCondition varchar(max)
DECLARE @SafeTextANDCondition varchar(max)
SET @SubANDCondition = ''
SET @TextANDCondition = ''
IF (@useandsearch > 0)
BEGIN
	SELECT @SafeSubANDCondition = 'FORMSOF(INFLECTIONAL,"' + REPLACE(@keywords, ',', '")'') AND CONTAINS(G.Subject,''FORMSOF(INFLECTIONAL,"') + '")'
	SELECT @SafeTextANDCondition = 'FORMSOF(INFLECTIONAL,"' + REPLACE(@keywords, ',', '")'') AND CONTAINS(G.Text,''FORMSOF(INFLECTIONAL,"') + '")'
	SET @SubANDCondition = 'AND ((CONTAINS(G.Subject,@SafeSubANDCondition))'
	SET @TextANDCondition = 'OR (CONTAINS(G.Text,@SafeTextANDCondition)))'

END
--PRINT (@SubANDCondition)
--PRINT (@TextANDCondition)

-- Setup the Status Conditions
DECLARE @StatusCondition varchar(200)
SET @StatusCondition = ''
IF @showsubmitted = 1 BEGIN SET @StatusCondition = ',4' END
IF @showapproved = 1 BEGIN SET @StatusCondition = @StatusCondition + ',1,9' END
IF @shownormal = 1 BEGIN SET @StatusCondition = @StatusCondition + ',3,4,5,6,8,11,12,13' END
SET @StatusCondition = SUBSTRING(@StatusCondition, 2, LEN(@StatusCondition)-1)
SET @StatusCondition = 'G.Status IN ('+@StatusCondition+') AND G.Hidden IS NULL'
--PRINT (@StatusCondition)

DECLARE @ApprovedMultiplier varchar(10)
DECLARE @SubmittedMultiplier varchar(10)
DECLARE @NormalMultiplier varchar(10)
DECLARE @DefaultMultiplier varchar(10)
SET @ApprovedMultiplier = '0.001'
SET @SubmittedMultiplier = '0.0005'
SET @NormalMultiplier = '0.0004'
SET @DefaultMultiplier = '0.0004'

DECLARE @ScoreClause varchar(500)
SET @ScoreClause =' 100 * SQRT(
				CASE WHEN Body.rank IS NOT NULL AND Subject.Rank IS NOT NULL THEN (Subject.rank + Body.rank) * 1.5
				WHEN Body.rank IS NULL AND Subject.Rank IS NOT NULL THEN Subject.rank * 2.0
				WHEN Body.rank IS NOT NULL AND Subject.Rank IS NULL THEN Body.rank * 0.5 END
				*
				CASE WHEN (G.Status = 1 OR G.Status = 9) THEN (' + @ApprovedMultiplier + ')
				WHEN G.Status = 4 THEN (' + @SubmittedMultiplier + ')
				WHEN G.Status = 3 THEN (' + @NormalMultiplier + ')
				ELSE (' + @DefaultMultiplier + ') END
			      )'
--PRINT (@ScoreClause)

-- Setup the full query from all the other bits
DECLARE @SearchQuery nvarchar(max)
SET @SearchQuery =
'DECLARE @Subject TABLE([key] int, rank int)
INSERT INTO @Subject SELECT * FROM CONTAINSTABLE(GuideEntries,subject,@SearchCondition,'+CAST(@maxresults AS varchar(4))+')
DECLARE @Body TABLE([key] int, rank int)
INSERT INTO @Body SELECT * FROM CONTAINSTABLE(Guideentries,text,@SearchCondition,'+CAST(@maxresults AS varchar(4))+')
SELECT TOP '+CAST(@maxresults AS varchar(4))+' ''Score'' = '+@ScoreClause+',
	G.*,
	''PrimarySite'' = CASE WHEN G.SiteID = '+CAST(@siteid AS varchar(4))+' THEN 1 ELSE 0 END
FROM 	@Subject Subject
	FULL JOIN @Body Body ON Subject.[key] = Body.[key]
	LEFT JOIN GuideEntries G WITH (NOLOCK)ON G.EntryID = Subject.[key] OR G.EntryID = Body.[key]
WHERE	(Subject.Rank IS NOT NULL OR Body.Rank IS NOT NULL)
	AND '+@StatusCondition+'
	'+@SubANDCondition+'
	'+@TextANDCondition+'
	'+@CategorySearch+'
ORDER BY PrimarySite DESC, ''Score'' DESC
'

--PRINT (@SearchQuery)
--EXEC (@SearchQuery)

	EXECUTE sp_executesql @SearchQuery, 
							N'@SearchCondition varchar(8000),
								@SafeSubANDCondition varchar(8000),
								@SafeTextANDCondition varchar(8000)', -- could truncate search conditions but in a safe way because condition not concatenated into executed SQL
							@SearchCondition = @SearchCondition, 
							@SafeSubANDCondition = @SafeSubANDCondition, 
							@SafeTextANDCondition = @SafeTextANDCondition 