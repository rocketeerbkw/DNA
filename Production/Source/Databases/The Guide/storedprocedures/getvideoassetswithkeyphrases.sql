/*********************************************************************************

	create procedure getvideoassetswithkeyphrases @keyphraselist VARCHAR(8000),
						@siteid int, @firstindex int, @lastindex int , @sortbycaption bit = null

	Author:		Steven Francis - from Martins SP
	Created:	08/11/2005
	Inputs:		@keyphraselist VARCHAR(8000),
				@siteid int, 
				@firstindex int, 
				@lastindex int , 
				@sortbycaption bit = null

	Outputs:	Video Asset dataset
	Purpose:	Returns the Video Asset dataset with the given key phrases
	
*********************************************************************************/
CREATE PROCEDURE getvideoassetswithkeyphrases @keyphraselist VARCHAR(8000), @siteid int, @firstindex int, @lastindex int, @sortbycaption bit = null
AS
BEGIN	
	
DECLARE @threadcount INT
DECLARE @query VARCHAR(1000)


--Get phrase count.
DECLARE @count INT; 
SELECT @count = count(*) FROM udf_splitvarchar(@keyphraselist)

--Get total video assets for site with key phrases.
declare @total int
SELECT @total =  COUNT(*) FROM (SELECT MA.ID FROM udf_splitvarchar(@keyphraselist) as s
	INNER JOIN dbo.KeyPhrases kp WITH (NOLOCK) ON kp.phrase = s.element
	INNER JOIN dbo.AssetKeyPhrases askp WITH (NOLOCK) ON askp.phraseid = kp.phraseid
	INNER JOIN dbo.MediaAsset MA WITH (NOLOCK) ON MA.ID = askp.AssetID 
	INNER JOIN dbo.VideoAsset vid WITH (NOLOCK) ON vid.MediaAssetID = MA.ID
	INNER JOIN dbo.MediaAssetLibrary mal WITH (NOLOCK) ON mal.MediaAssetID = MA.ID
	AND MA.SiteId = @siteid AND MA.Hidden IS NULL GROUP BY MA.ID HAVING count(kp.PhraseID) = @count) AS TotalAssets

-- select assets into a temporary table to implement skip and show.
create table #tempassets(id int NOT NULL IDENTITY(0,1)PRIMARY KEY, AssetID int NOT NULL)


	
IF @sortbycaption IS NOT NULL
	BEGIN
		insert into #tempassets (assetID)
		SELECT TOP(@lastindex) MA.ID
			FROM udf_splitvarchar(@keyphraselist) as s
			INNER JOIN dbo.KeyPhrases kp WITH (NOLOCK) ON kp.phrase = s.element
			INNER JOIN dbo.AssetKeyPhrases askp WITH (NOLOCK) ON askp.phraseid = kp.phraseid
			INNER JOIN dbo.MediaAsset MA WITH (NOLOCK) ON MA.ID = askp.AssetID 
			INNER JOIN dbo.VideoAsset vid WITH (NOLOCK) ON vid.MediaAssetID = MA.ID
			INNER JOIN dbo.MediaAssetLibrary mal WITH (NOLOCK) ON mal.MediaAssetID = MA.ID
			AND MA.SiteId = @siteid AND MA.Hidden IS NULL
			GROUP BY MA.ID, MA.LastUpdated, MA.Caption HAVING count(kp.PhraseID) = @count
			ORDER BY MA.Caption ASC
	END
ELSE
	BEGIN
		insert into #tempassets (assetID)
		SELECT TOP(@lastindex) MA.ID
			FROM udf_splitvarchar(@keyphraselist) as s
			INNER JOIN dbo.KeyPhrases kp WITH (NOLOCK) ON kp.phrase = s.element
			INNER JOIN dbo.AssetKeyPhrases askp WITH (NOLOCK) ON askp.phraseid = kp.phraseid
			INNER JOIN dbo.MediaAsset MA WITH (NOLOCK) ON MA.ID = askp.AssetID 
			INNER JOIN dbo.VideoAsset vid WITH (NOLOCK) ON vid.MediaAssetID = MA.ID
			INNER JOIN dbo.MediaAssetLibrary mal WITH (NOLOCK) ON mal.MediaAssetID = MA.ID
			AND MA.SiteId = @siteid AND MA.Hidden IS NULL
			GROUP BY MA.ID, MA.LastUpdated, MA.Caption HAVING count(kp.PhraseID) = @count
			ORDER BY MA.LastUpdated DESC
	END
	--Remove entries not requested - skip and show.
	delete from #tempassets where id > @lastindex or id < @firstindex

--Get count.
select @count = count(*) from ( select * from #tempassets) as s

SELECT 	MA.ID 'assetid', 
	MA.caption,
	MA.contenttype,
	MA.mimetype,
	MA.ownerid,
	MA.ExtraElementXML,
	assphrases.phrase 'phrase',
	@count 'count',
	@total 'total',
	MA.Hidden

FROM #tempassets tmp
INNER JOIN dbo.MediaAsset MA ON MA.ID = tmp.AssetID
INNER JOIN
(	
	--key phrases for each asset.
	select askp.AssetId, Phrase from KeyPhrases p
	INNER JOIN dbo.AssetKeyPhrases askp WITH(NOLOCK) ON askp.PhraseId = p.PhraseId 
) AS assphrases ON assphrases.assetid = tmp.assetid 

ORDER BY tmp.id

DROP TABLE #tempassets
		
RETURN @@ERROR
END