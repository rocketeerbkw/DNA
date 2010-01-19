CREATE PROCEDURE getarticles_generatearticlessortedwithindexedviews
@keyphraselist VARCHAR(1000) OUTPUT, 
@namespacelist VARCHAR(1000),
@sortbyrating bit,
@siteid int,
@sql nvarchar(max) OUTPUT
AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT * INTO #KeyPhraseNamespacePairs FROM dbo.udf_getkeyphrasenamespacepairs (@namespacelist, @keyphraselist) kpns;

	CREATE TABLE #PhraseNameSpaceIDs(i INT IDENTITY PRIMARY KEY,id INT);

	INSERT INTO #PhraseNameSpaceIDs 
		SELECT pns.PhraseNameSpaceID
			FROM #KeyPhraseNamespacePairs kpns
			INNER JOIN dbo.KeyPhrases kp on kpns.Phrase = kp.phrase
			INNER JOIN dbo.NameSpaces ns on kpns.Namespace = ns.Name
			INNER JOIN dbo.PhraseNameSpaces pns ON kp.PhraseID = pns.PhraseID AND ns.NameSpaceID = pns.NameSpaceID
		UNION
		SELECT pns.PhraseNameSpaceID 
			FROM #KeyPhraseNamespacePairs kpns 
			INNER JOIN dbo.KeyPhrases kp on kpns.Phrase = kp.phrase 
			INNER JOIN dbo.PhraseNameSpaces pns ON kp.PhraseID = pns.PhraseID AND pns.NameSpaceID IS NULL AND kpns.Namespace IS NULL 
		UNION
		SELECT pns.PhraseNameSpaceID 
			FROM #KeyPhraseNamespacePairs kpns
			INNER JOIN dbo.KeyPhrases kp on kpns.Phrase = kp.phrase
			INNER JOIN dbo.PhraseNameSpaces pns ON kp.PhraseID = pns.PhraseID
			INNER JOIN dbo.ArticleKeyPhrases akp ON pns.PhraseNameSpaceID = akp.PhraseNameSpaceID
			WHERE kpns.Namespace = '_any'
			
	DECLARE @numPhraseNameSpaceIDs int
	SELECT @numPhraseNameSpaceIDs=COUNT(*) FROM #PhraseNameSpaceIDs
	
	IF ISNULL(@numPhraseNameSpaceIDs,0)=0
	BEGIN
		SELECT @sql = @sql + N'WITH Sorted AS (SELECT -1 AS EntryID,0 AS rn,0 AS Total) '
		RETURN
	END

	DECLARE @i int, @id int

	SET @i=1
	SET @keyphraselist=''
	WHILE @i <=@numPhraseNameSpaceIDs
	BEGIN
		SELECT @id=(SELECT id FROM #PhraseNameSpaceIDs WHERE i=@i)
		SET @keyphraselist=@keyphraselist+CAST(@id AS varchar)
		
		IF @i < @numPhraseNameSpaceIDs
		BEGIN
			SELECT @keyphraselist = @keyphraselist + '|'
		END
		SET @i=@i+1					
	END
	
	SELECT @sql=@sql + N'CREATE TABLE #PhraseNameSpaceIDs(i INT IDENTITY PRIMARY KEY,id INT);
			INSERT INTO #PhraseNameSpaceIDs	SELECT element FROM dbo.udf_splitint(@keyphraselist);'

	DECLARE @overclause VARCHAR(100), @indexedview varchar(100), @groupbyclause VARCHAR(100)

	-- Candidate articles
	IF ( @sortbyrating = 1 )
	BEGIN
	    -- Sort By Rating
		SET @overclause='ORDER BY AverageRating DESC, LastUpdated DESC'
		SET @indexedview='VVisibleArticleKeyPhrasesWithLastUpdatedAndAverageRating'
		SET @groupbyclause='EntryID,AverageRating,LastUpdated'
	END
	ELSE
	BEGIN
	    --Sort by DateCreated - Default.
		SET @overclause='ORDER BY DateCreated DESC'
		SET @indexedview='VVisibleArticleKeyPhrasesWithDateCreated'
		SET @groupbyclause='EntryID,DateCreated'
	END
	
	SELECT @sql = @sql + 
	   N'WITH Entries AS
		(
			SELECT EntryID, ROW_NUMBER() OVER('+@overclause+') rn
				FROM 
				('

	SET @i=1
	WHILE @i <=@numPhraseNameSpaceIDs
	BEGIN
		IF @i > 1
		BEGIN
			SELECT @sql = @sql + N' UNION ALL '
		END

		SELECT @sql = @sql + N'
				SELECT * FROM '+@indexedview+' WITH(NOEXPAND)
					WHERE PhraseNamespaceID=(SELECT id FROM #PhraseNameSpaceIDs WHERE i='+CAST(@i AS VARCHAR)+') AND siteid=@siteid'
		SET @i=@i+1					
	END

	SELECT @sql = @sql + N') s'

    DECLARE @606SiteId int
	SELECT @606SiteId=siteid FROM Sites WHERE urlname='606'

	-- Only restrict the number of results by datecreated for 606
	IF @siteid=@606SiteId
	BEGIN
		SELECT @sql = @sql + N'
			WHERE datecreated > DATEADD(mm,-1,GETDATE())'
	END

		SELECT @sql = @sql + N'
			GROUP BY '+@groupbyclause

		SELECT @sql = @sql + N'
		HAVING COUNT(*)='+CAST(@numPhraseNameSpaceIDs AS VARCHAR)+'
	),
	Total AS
	(
		-- It''s important to keep the TOP in to persuade it to use a merge join
		SELECT TOP(1001000) EntryID FROM Entries order by rn
	),
	Sorted AS
	(
		SELECT EntryID,rn, (SELECT COUNT(*) FROM Total) AS Total
			FROM Entries
			WHERE (rn BETWEEN @firstindex AND @lastindex)
	)'

RETURN @@ERROR