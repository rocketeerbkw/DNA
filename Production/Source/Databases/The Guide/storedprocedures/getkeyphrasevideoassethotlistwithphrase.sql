Create Procedure getkeyphrasevideoassethotlistwithphrase @siteid int, @keyphraselist VARCHAR(500), @skip int = 0, @show int = 500, @sortbyphrase bit = null
AS

DECLARE @elements TABLE(element VARCHAR(100) COLLATE database_default)
INSERT @elements SELECT element FROM dbo.udf_splitvarchar(@keyphraselist)

DECLARE @AssociatedPhrases TABLE( PhraseId int, Phrase VARCHAR(100) COLLATE database_default )

--Get number of key phrases
--DECLARE @count INT; 
--SELECT @count = count(*) FROM @elements

-- Get the discussion that have the phrase  @keyphraselist
--Optimised for only one key phrase.
INSERT @AssociatedPhrases select distinct  kp2.PhraseId, kp2.Phrase FROM AssetKeyPhrases akp
INNER JOIN dbo.KeyPhrases kp WITH (NOLOCK) ON kp.PhraseId = akp.PhraseId 
INNER JOIN @elements svc ON svc.element = kp.Phrase
INNER JOIN dbo.MediaAsset MA WITH (NOLOCK) ON MA.ID = akp.AssetId 
INNER JOIN dbo.VideoAsset vid WITH (NOLOCK) ON vid.MediaAssetID = MA.ID
INNER JOIN dbo.MediaAssetLibrary mal WITH (NOLOCK) ON mal.MediaAssetID = MA.ID

--Get the phrases for each of the discussions
INNER JOIN dbo.AssetKeyPhrases akp2 ON akp2.AssetId = akp.AssetId
INNER JOIN dbo.KeyPhrases kp2 ON kp2.PhraseId = akp2.PhraseId
WHERE MA.siteid = @siteid AND MA.Hidden IS NULL 

--WHERE kp.Phrase = @keyphraselist


-- Remove the initial search phrases - only want related phrases
DELETE FROM @AssociatedPhrases WHERE Phrase IN ( Select element FROM @elements )

--Remove Site Key Phrases.
DELETE FROM @AssociatedPhrases WHERE PhraseId IN ( SELECT PhraseId FROM SiteKeyPhrases where siteid = @siteid )


-- Normalisation factor 
DECLARE @maxphrasecount DECIMAL
SELECT @maxphrasecount =  ISNULL(MAX(kmax.[count]),1.0)
from 
( select ak.PhraseId,
	count(*) 'count'
	from dbo.AssetKeyPhrases ak
	INNER JOIN dbo.MediaAsset MA WITH (NOLOCK) ON ak.AssetId = MA.ID
	INNER JOIN dbo.VideoAsset vid WITH (NOLOCK) ON vid.MediaAssetID = MA.ID
	INNER JOIN dbo.MediaAssetLibrary mal WITH (NOLOCK) ON mal.MediaAssetID = MA.ID
	WHERE MA.siteid = @siteid AND MA.Hidden IS NULL 
	group by ak.PhraseId 
) AS kmax
INNER JOIN @AssociatedPhrases ap ON ap.PhraseId = kmax.PhraseId 



--create temp table to select into for skip and show.
DECLARE @temphotphrases TABLE( id int NOT NULL IDENTITY(1,1) PRIMARY KEY, Rank float, Phrase VARCHAR(256), PhraseId int, SortByPhrase VARCHAR(100) )

insert @temphotphrases(Rank,Phrase,PhraseId,SortByPhrase)
select ak1.[count]/@maxphrasecount 'Rank',
		kk.Phrase,
		kk.PhraseId,
		'SortByPhrase' = CASE WHEN @sortbyphrase IS NOT NULL THEN kk.Phrase ELSE NULL END
FROM KeyPhrases kk
INNER JOIN (

--No of times a phrase has been associated/tagged to an asset.
select ak.PhraseId,
	count(*) 'count'
from dbo.AssetKeyPhrases ak
INNER JOIN dbo.MediaAsset MA WITH (NOLOCK) ON ak.AssetId = MA.ID
INNER JOIN dbo.VideoAsset vid WITH (NOLOCK) ON vid.MediaAssetID = MA.ID
INNER JOIN dbo.MediaAssetLibrary mal WITH (NOLOCK) ON mal.MediaAssetID = MA.ID
WHERE MA.siteid = @siteid AND MA.Hidden IS NULL 
group by ak.PhraseId ) AS ak1 ON kk.PhraseId = ak1.PhraseId


--filter on phrases that are also associated to the same discussions.
INNER JOIN @AssociatedPhrases ap ON ap.PhraseId = kk.PhraseId 

ORDER BY SortByPhrase ASC,Rank DESC

-- Remove entries to be skipped. 
declare @count int
select @count = MAX(id) from @temphotphrases
delete from @temphotphrases where id < @skip or id > @skip + @show

select @count 'count', * from @temphotphrases