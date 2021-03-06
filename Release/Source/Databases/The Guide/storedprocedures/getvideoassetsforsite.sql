/*********************************************************************************

	create procedure getvideoassetsforsite @siteid int, @firstindex int, @lastindex int, @sortbycaption bit = null

	Author:		Steven Francis - from Martins SP
	Created:	08/11/2005
	Inputs:		@siteid int, @firstindex int, @lastindex int, @sortbycaption bit = null
	Outputs:	Video Assets and Phrases
	Purpose:	Returns the Video Assets for a site
	
*********************************************************************************/
CREATE PROCEDURE getvideoassetsforsite @siteid int, @firstindex int, @lastindex int, @sortbycaption bit = null
AS
BEGIN	
	
DECLARE @query VARCHAR(8000)
--Get total video assets for site.
declare @total int
SELECT @total =  COUNT(*) FROM dbo.VideoAsset AS V WITH(NOLOCK) 
	INNER JOIN dbo.MediaAsset AS MA WITH(NOLOCK) ON V.MediaAssetID = MA.ID
	INNER JOIN dbo.MediaAssetLibrary AS MAL WITH(NOLOCK) ON MAL.MediaAssetID = MA.ID
	WHERE MA.SiteId = @siteid AND MA.Hidden IS NULL

-- select video assets into a temporary table to implement skip and show.
create table #tempassets(id int NOT NULL IDENTITY(0,1)PRIMARY KEY, AssetID int NOT NULL)


IF @sortbycaption IS NOT NULL
	BEGIN
	INSERT INTO #tempassets(assetID) 
	SELECT TOP(@lastindex + 1) MA.ID
	FROM dbo.VideoAsset AS V WITH(NOLOCK) 
	INNER JOIN dbo.MediaAsset AS MA WITH(NOLOCK) ON V.MediaAssetID = MA.ID
	INNER JOIN dbo.MediaAssetLibrary AS MAL WITH(NOLOCK) ON MAL.MediaAssetID = MA.ID
	WHERE MA.SiteId = @siteid AND MA.Hidden IS NULL
	ORDER BY MA.Caption ASC
	END
ELSE
	BEGIN
	INSERT INTO #tempassets(assetID) 
	SELECT TOP(@lastindex + 1) MA.ID
	FROM dbo.VideoAsset AS V WITH(NOLOCK) 
	INNER JOIN dbo.MediaAsset AS MA WITH(NOLOCK) ON V.MediaAssetID = MA.ID
	INNER JOIN dbo.MediaAssetLibrary AS MAL WITH(NOLOCK) ON MAL.MediaAssetID = MA.ID
	WHERE MA.SiteId = @siteid AND MA.Hidden IS NULL
	ORDER BY MA.LastUpdated DESC
	END

--Get count.
declare @count int
select @count = count(*) from ( select * from #tempassets) as s

--Remove entries not requested - skip and show.
delete from #tempassets where id > @lastindex or id < @firstindex

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
LEFT JOIN
(	
	--key phrases for each asset.
	select askp.AssetId, Phrase from KeyPhrases p
	INNER JOIN AssetKeyPhrases askp WITH(NOLOCK) ON askp.PhraseId = p.PhraseId 
) AS assphrases ON assphrases.assetid = tmp.assetid 

ORDER BY tmp.id
		


drop table #tempassets
		

RETURN @@ERROR
END