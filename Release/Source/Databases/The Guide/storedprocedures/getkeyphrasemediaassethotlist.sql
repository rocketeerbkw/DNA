CREATE PROCEDURE getkeyphrasemediaassethotlist @siteid int, @skip int = 0, @show int = 500, @sortbyphrase bit = null
AS
	DECLARE @query VARCHAR(8000)
	DECLARE @PhraseCountMax int
	DECLARE @TotalPhrases int
	DECLARE @Count int

	-- select the hotlist into a temporary table to implement skip and show.
	create table #temphotlist (id int NOT NULL IDENTITY(0,1)PRIMARY KEY, Phrase varchar(100) NOT NULL, PhraseCount real NOT NULL)

	INSERT INTO #temphotlist SELECT kp.Phrase 'Phrase' , Count (kp.Phrase) 'PhraseCount'
		FROM dbo.AssetKeyPhrases akp
			INNER JOIN dbo.MediaAsset MA WITH(NOLOCK) ON akp.AssetID = MA.ID
			INNER JOIN dbo.KeyPhrases kp WITH(NOLOCK) ON kp.PhraseId = akp.PhraseID
			INNER JOIN dbo.MediaAssetLibrary mal WITH(NOLOCK) ON mal.MediaAssetID = MA.ID
		WHERE MA.SiteID = @siteid AND MA.Hidden IS NULL 
		GROUP BY akp.PhraseId, kp.Phrase
		ORDER BY PhraseCount DESC

	SELECT @PhraseCountMax = MAX(PhraseCount) FROM #temphotlist
	 
	SELECT @TotalPhrases = Count(*) FROM #temphotlist

	--Remove entries not requested - skip and show.
	DELETE FROM #temphotlist WHERE id < @skip OR id >= @skip + @show
	
	SELECT @Count = Count(*) FROM #temphotlist

	SELECT 	Phrase,
			PhraseCount/CAST(@PhraseCountMax AS REAL) 'Rank',
			@Count 'Count',
			@TotalPhrases 'Total Phrases'
	FROM #temphotlist tmp	 

	DROP TABLE #temphotlist
	
RETURN @@ERROR