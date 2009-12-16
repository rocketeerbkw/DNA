/*********************************************************************************

	create procedure getusersaudioassets @userid int, @firstindex int, @lastindex int, @sortbycaption bit = null as

	Author:		Steven Francis
	Created:	01/12/2005
	Inputs:		@userid - ID of user
				@firstindex - for skip and show
				@lastindex - for skip and show
				@sortbycaption bit = null
				@owner bit = null
	Outputs:	Returns the Users Audio Assets
	Purpose:	Get the details of audio assets for a given user
	
*********************************************************************************/
CREATE PROCEDURE getusersaudioassets @userid int, @firstindex int, @lastindex int, @owner bit = null, @sortbycaption bit = null
AS
BEGIN	
	
DECLARE @query VARCHAR(1000)
DECLARE @count INT; 
DECLARE @total INT;

IF @owner IS NOT NULL
	BEGIN
		--Get total audio assets for user.
		SELECT @total =  COUNT(*) FROM MediaAsset MA WITH(NOLOCK) 
			INNER JOIN dbo.AudioAsset AS A WITH(NOLOCK) ON A.MediaAssetID = MA.ID
			WHERE MA.OwnerID = @userid AND (MA.Hidden <> 1 OR MA.Hidden IS NULL) 		
	END
ELSE
	BEGIN
		--Get total audio assets that have passed moderation for the given user.
		SELECT @total =  COUNT(*) FROM MediaAsset MA WITH(NOLOCK) 
			INNER JOIN dbo.AudioAsset AS A WITH(NOLOCK) ON A.MediaAssetID = MA.ID
			WHERE MA.OwnerID = @userid AND MA.Hidden IS NULL		
	END
 
-- select audio assets into a temporary table to implement skip and show.
CREATE TABLE #tempusraudioassets(id int NOT NULL IDENTITY(0,1)PRIMARY KEY, MediaAssetID int NOT NULL)


--if it is the viewing user select only the audio assets that have not been failed else only the passed ones
IF @owner IS NOT NULL
	BEGIN
	IF @sortbycaption IS NOT NULL
	BEGIN
		INSERT INTO #tempusraudioassets (MediaAssetID)
			SELECT TOP(@lastindex) MA.ID
			FROM dbo.AudioAsset AS A WITH(NOLOCK) 
			INNER JOIN dbo.MediaAsset AS MA WITH(NOLOCK) ON A.MediaAssetID = MA.ID
			WHERE MA.OwnerID = @userid
			AND (MA.Hidden <> 1 OR MA.Hidden IS NULL)
			ORDER BY MA.Caption ASC
	END
	ELSE
	BEGIN
		INSERT INTO #tempusraudioassets (MediaAssetID)
			SELECT TOP(@lastindex) MA.ID
			FROM dbo.AudioAsset AS A WITH(NOLOCK) 
			INNER JOIN dbo.MediaAsset AS MA WITH(NOLOCK) ON A.MediaAssetID = MA.ID
			WHERE MA.OwnerID = @userid
			AND (MA.Hidden <> 1 OR MA.Hidden IS NULL)
			ORDER BY MA.LastUpdated DESC
	END
	END
ELSE
	BEGIN
	IF @sortbycaption IS NOT NULL
	BEGIN
		INSERT INTO #tempusraudioassets (MediaAssetID)
			SELECT TOP(@lastindex) MA.ID
			FROM dbo.AudioAsset AS A WITH(NOLOCK) 
			INNER JOIN dbo.MediaAsset AS MA WITH(NOLOCK) ON A.MediaAssetID = MA.ID
			WHERE MA.OwnerID = @userid
			AND MA.Hidden IS NULL
			ORDER BY MA.Caption ASC
	END
	ELSE
	BEGIN
		INSERT INTO #tempusraudioassets (MediaAssetID)
			SELECT TOP(@lastindex) MA.ID
			FROM dbo.AudioAsset AS A WITH(NOLOCK) 
			INNER JOIN dbo.MediaAsset AS MA WITH(NOLOCK) ON A.MediaAssetID = MA.ID
			WHERE MA.OwnerID = @userid
			AND MA.Hidden IS NULL
			ORDER BY MA.LastUpdated DESC
	END
	END
	

	--Remove entries not requested - skip and show.
	DELETE FROM #tempusraudioassets where id > @lastindex or id < @firstindex

--Get count.
select @count = count(*) from ( select * from #tempusraudioassets) as s

SELECT 	MA.ID,
		MA.ID As 'MediaAssetID',		
		MA.SiteID,
		MA.Caption,
		MA.Filename,
		MA.MimeType,
		MA.ContentType,
		MA.ExtraElementXML,
		MA.OwnerID,
		MA.DateCreated,
		MA.LastUpdated,
		MA.DateCreated AS 'MADateCreated',
		MA.LastUpdated AS 'MALastUpdated',
		MA.Description,
		MA.Hidden,
		MA.ExternalLinkURL,
		@count 'count',
		@total 'total',
		u.UserName,
		u.FirstNames,
		u.LastName,
		u.Status,
		u.Active,
		u.Postcode,
		u.Area,
		u.TaxonomyNode,
		u.UnreadPublicMessageCount,
		u.UnreadPrivateMessageCount,
		u.Region,
		u.HideLocation,
		u.HideUserName,
		u.AcceptSubscriptions,
		ISNULL(csu.Score, 0.0) AS 'ZeitgeistScore'


FROM #tempusraudioassets tmp
INNER JOIN dbo.MediaAsset MA WITH(NOLOCK) ON MA.ID = tmp.MediaAssetID
INNER JOIN dbo.AudioAsset AS A WITH(NOLOCK) ON A.MediaAssetID = tmp.MediaAssetID
INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = MA.OwnerID
LEFT JOIN dbo.ContentSignifUser csu  WITH(NOLOCK) ON u.Userid = csu.Userid AND csu.SiteID = MA.SiteID
ORDER BY tmp.id
		
RETURN @@ERROR
END