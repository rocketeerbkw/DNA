/*********************************************************************************

	create procedure getkeyphrasearticlevideoassethotlistwithphrase @keyphraselist VARCHAR(8000), @siteid int, @firstindex int, @lastindex int as

	Author:		Steven Francis
	Created:	16/12/2005
	Inputs:		siteid, 
				phrases filter - hot list will be based on articles that are associated with these phrases
				skp & show params 
				ssortByParam - sort by rank ( default ) or sort by phrase.
	Outputs:	
	Purpose:	Get an article with video asset tag cloud based on the provided site and phrases filter.
	
*********************************************************************************/
Create Procedure getkeyphrasearticlevideoassethotlistwithphrase @siteid int, @keyphraselist VARCHAR(500), @skip int = 0, @show int = 500, @sortbyphrase bit = null
AS

DECLARE @elements TABLE(element VARCHAR(100) COLLATE database_default)
INSERT @elements SELECT element FROM dbo.udf_splitvarchar(@keyphraselist)

DECLARE @AssociatedPhrases TABLE( PhraseId int, Phrase VARCHAR(100) COLLATE database_default )

--Get number of key phrases
--DECLARE @count INT; 
--SELECT @count = count(*) FROM @elements

-- Get the discussion that have the phrase  @keyphraselist
--Optimised for only one key phrase.
INSERT @AssociatedPhrases SELECT DISTINCT  kp2.PhraseId, kp2.Phrase FROM ArticleKeyPhrases akp
INNER JOIN dbo.PhraseNameSpaces pns WITH(NOLOCK) ON akp.PhraseNameSpaceID = pns.PhraseNameSpaceID
INNER JOIN KeyPhrases kp ON pns.PhraseId = kp.PhraseId
INNER JOIN  @elements svc ON svc.element = kp.Phrase
INNER JOIN dbo.GuideEntries g ON g.EntryId = akp.EntryId AND g.siteid = @siteid
INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.EntryID = akp.EntryID
INNER JOIN dbo.VideoAsset vid WITH(NOLOCK) ON vid.MediaAssetID = AMA.MediaAssetID
INNER JOIN dbo.MediaAsset MA WITH (NOLOCK) ON MA.ID = AMA.MediaAssetID

--Get the phrases for each of the discussions
INNER JOIN ArticleKeyPhrases akp2 ON akp2.EntryId = akp.EntryId
INNER JOIN dbo.PhraseNameSpaces pns2 WITH(NOLOCK) ON akp2.PhraseNameSpaceID = pns2.PhraseNameSpaceID
INNER JOIN KeyPhrases kp2 ON pns2.PhraseID = kp2.PhraseId
WHERE g.siteid = @siteid AND MA.Hidden IS NULL
  AND pns.NameSpaceID IS NULL -- for the first step in namespace migration only 'old' phrases will be seleted i.e. those without a namespace
  AND pns2.NameSpaceID IS NULL -- for the first step in namespace migration only 'old' phrases will be seleted i.e. those without a namespace

--WHERE kp.Phrase = @keyphraselist


-- Remove the initial search phrases - only want related phrases
DELETE FROM @AssociatedPhrases WHERE Phrase IN ( SELECT element FROM @elements )

--Remove Site Key Phrases.
DELETE FROM @AssociatedPhrases WHERE PhraseId IN ( SELECT PhraseId FROM SiteKeyPhrases WHERE siteid = @siteid )


-- Normalisation factor 
DECLARE @maxphrasecount DECIMAL
SELECT @maxphrasecount =  ISNULL(MAX(kmax.[count]),1.0)
FROM 
( SELECT kp.PhraseId,
	COUNT(*) 'count'
	FROM ArticleKeyPhrases ak
	INNER JOIN dbo.PhraseNameSpaces pns WITH(NOLOCK) ON ak.PhraseNameSpaceID = pns.PhraseNameSpaceID
	INNER JOIN dbo.KeyPhrases kp WITH(NOLOCK) ON pns.PhraseID = kp.PhraseID
	INNER JOIN dbo.GuideEntries g ON g.EntryId = ak.EntryId AND g.siteid = @siteid
	INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.EntryID = ak.EntryID
	INNER JOIN dbo.VideoAsset vid WITH(NOLOCK) ON vid.MediaAssetID = AMA.MediaAssetID
	INNER JOIN dbo.MediaAsset MA WITH (NOLOCK) ON MA.ID = AMA.MediaAssetID
	WHERE g.siteid = @siteid AND MA.Hidden IS NULL
	  AND pns.NameSpaceID IS NULL -- for the first step in namespace migration only 'old' phrases will be seleted i.e. those without a namespace
	GROUP BY kp.PhraseId 
) AS kmax
INNER JOIN @AssociatedPhrases ap ON ap.PhraseId = kmax.PhraseId 



--create temp table to select into for skip and show.
DECLARE @temphotphrases TABLE( id int NOT NULL IDENTITY(1,1) PRIMARY KEY, Rank float, Phrase VARCHAR(256), PhraseId int, SortByPhrase VARCHAR(100) )

INSERT @temphotphrases(Rank,Phrase,PhraseId,SortByPhrase)
SELECT ak1.[count]/@maxphrasecount 'Rank',
		kk.Phrase,
		kk.PhraseId,
		'SortByPhrase' = CASE WHEN @sortbyphrase IS NOT NULL THEN kk.Phrase ELSE NULL END
FROM KeyPhrases kk
INNER JOIN (

--No of times a phrase has been associated/tagged to a thread.
SELECT kp.PhraseId,
	COUNT(*) 'count'
FROM dbo.ArticleKeyPhrases ak
INNER JOIN dbo.PhraseNameSpaces pns WITH(NOLOCK) ON ak.PhraseNameSpaceID = pns.PhraseNameSpaceID
INNER JOIN dbo.KeyPhrases kp WITH(NOLOCK) ON pns.PhraseID = kp.PhraseID
INNER JOIN dbo.GuideEntries g ON g.EntryId = ak.EntryId AND g.siteid = @siteid
INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.EntryID = ak.EntryID
INNER JOIN dbo.VideoAsset vid WITH(NOLOCK) ON vid.MediaAssetID = AMA.MediaAssetID
INNER JOIN dbo.MediaAsset MA WITH (NOLOCK) ON MA.ID = AMA.MediaAssetID
WHERE g.siteid = @siteid AND MA.Hidden IS NULL
  AND pns.NameSpaceID IS NULL -- for the first step in namespace migration only 'old' phrases will be seleted i.e. those without a namespace
GROUP BY kp.PhraseId ) AS ak1 ON kk.PhraseId = ak1.PhraseId


--filter on phrases that are also associated to the same discussions.
INNER JOIN @AssociatedPhrases ap ON ap.PhraseId = kk.PhraseId 

ORDER BY SortByPhrase ASC,Rank DESC

-- Remove entries to be skipped. 
DECLARE @count INT
SELECT @count = MAX(id) FROM @temphotphrases
DELETE FROM @temphotphrases WHERE id < @skip OR id > @skip + @show

SELECT @count 'count', Rank, Phrase, PhraseId, SortByPhrase FROM @temphotphrases
