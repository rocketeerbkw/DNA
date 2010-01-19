/*********************************************************************************

	create procedure getkeyphrasearticleimageassethotlist @keyphraselist VARCHAR(8000), @siteid int, @firstindex int, @lastindex int as

	Author:		Steven Francis
	Created:	16/01/2006
	Inputs:		siteid, 
				phrases filter - hot list will be based on articles that are associated with these phrases
				skp & show params 
				ssortByParam - sort by rank ( default ) or sort by phrase.
	Outputs:	
	Purpose:	Get an articles with image assets tag cloud based on the provided site and phrases filter.
	
*********************************************************************************/
CREATE PROCEDURE getkeyphrasearticleimageassethotlist @siteid int, @skip int = 0, @show int = 500, @sortbyphrase bit = null
AS
	DECLARE @query VARCHAR(8000)
	DECLARE @PhraseCountMax int
	DECLARE @TotalPhrases int
	DECLARE @Count int

	-- select the hotlist into a temporary table to implement skip and show.
	create table #temphotlist (id int NOT NULL IDENTITY(0,1)PRIMARY KEY, Phrase varchar(100) NOT NULL, PhraseCount real NOT NULL)

	INSERT INTO #temphotlist SELECT kp.Phrase 'Phrase' , Count (kp.Phrase) 'PhraseCount'
		  FROM dbo.ArticleKeyPhrases akp WITH(NOLOCK)
			INNER JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.EntryID = akp.EntryID
			INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.EntryID = akp.EntryID
			INNER JOIN dbo.PhraseNameSpaces pns WITH(NOLOCK) ON akp.PhraseNameSpaceID = pns.PhraseNameSpaceID
			INNER JOIN dbo.KeyPhrases kp WITH(NOLOCK) ON pns.PhraseID = kp.PhraseId
			INNER JOIN dbo.ImageAsset img WITH(NOLOCK) ON img.MediaAssetID = AMA.MediaAssetID
			INNER JOIN dbo.MediaAsset MA WITH(NOLOCK) ON MA.ID = AMA.MediaAssetID
		WHERE g.SiteID = @siteid AND MA.Hidden IS NULL
		  AND pns.NameSpaceID IS NULL -- for the first step in namespace migration only 'old' phrases will be seleted i.e. those without a namespace
		GROUP BY kp.PhraseId, kp.Phrase
		ORDER BY PhraseCount DESC

	SELECT @PhraseCountMax = MAX(PhraseCount) FROM #temphotlist
	 
	SELECT @TotalPhrases = Count(*) FROM #temphotlist

	--Remove entries not requested - skip and show.
	DELETE FROM #temphotlist WHERE id < @skip OR id >= @skip + @show
	
	SELECT @Count = Count(*) FROM #temphotlist

	SELECT 	Phrase,
			PhraseCount*1.0/CAST(@PhraseCountMax AS FLOAT) 'Rank',
			@Count 'Count',
			@TotalPhrases 'Total Phrases'
	FROM #temphotlist tmp	 

	DROP TABLE #temphotlist

RETURN @@ERROR