/*********************************************************************************

	create procedure getusersarticleswithmediaassets @userid int, @firstindex int, @lastindex int, @owner bit = null, @sortbycaption bit = null, @sortbyrating bit = null as

	Author:		Steven Francis
	Created:	11/01/200
	Inputs:		@userid - ID of user
				@firstindex - for skip and show
				@lastindex - for skip and show
				@owner bit = null
				@sortbycaption bit = null
				@sortbyrating bit = null
	Outputs:	Returns the Users Media Assets
	Purpose:	Get the details of articles with media assets for a given user
	
*********************************************************************************/
CREATE PROCEDURE getusersarticleswithmediaassets @userid int, @firstindex int, @lastindex int, @owner bit = null, @sortbycaption bit = null, @sortbyrating bit = null
AS
BEGIN	
	
DECLARE @query VARCHAR(1000)
DECLARE @count INT; 
DECLARE @total INT;

IF @owner IS NOT NULL
	BEGIN
		--Get total articles with media assets for the viewing user.
		SELECT @total =  COUNT(*) FROM dbo.MediaAsset MA WITH(NOLOCK) 
				INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
				WHERE MA.OwnerID = @userid AND (MA.Hidden <> 1 OR MA.Hidden IS NULL) 			
	END
ELSE
	BEGIN
		--Get total articles with media assets that have passed moderation for the user selected.
		SELECT @total =  COUNT(*) FROM dbo.MediaAsset MA WITH(NOLOCK) 
				INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
				WHERE MA.OwnerID = @userid AND MA.Hidden IS NULL		
	END
 
-- select assets into a temporary table to implement skip and show.
CREATE TABLE #tempusrassets(id int NOT NULL IDENTITY(0,1)PRIMARY KEY, MediaAssetID int NOT NULL)


--if it is the viewing user select only the assets that have not been failed else only the passed ones
IF @owner IS NOT NULL
	BEGIN
	IF @sortbycaption IS NOT NULL
		BEGIN
		INSERT INTO #tempusrassets (MediaAssetID)
			SELECT TOP(@lastindex) MA.ID
			FROM dbo.MediaAsset MA WITH(NOLOCK) 
			INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
			LEFT JOIN dbo.PageVotes pv WITH(NOLOCK) ON AMA.entryid=pv.itemid/10 and pv.itemtype=1
			LEFT JOIN dbo.Votes v WITH(NOLOCK) ON pv.voteid=v.voteid and v.type=3
			WHERE MA.OwnerID = @userid
			AND (MA.Hidden <> 1 OR MA.Hidden IS NULL)
			ORDER BY MA.Caption ASC
		END
	ELSE IF @sortbyrating IS NOT NULL
		BEGIN
		INSERT INTO #tempusrassets (MediaAssetID)
			SELECT TOP(@lastindex) MA.ID
			FROM dbo.MediaAsset MA WITH(NOLOCK) 
			INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
			LEFT JOIN dbo.PageVotes pv WITH(NOLOCK) ON AMA.entryid=pv.itemid/10 and pv.itemtype=1
			LEFT JOIN dbo.Votes v WITH(NOLOCK) ON pv.voteid=v.voteid and v.type=3
			WHERE MA.OwnerID = @userid
			AND (MA.Hidden <> 1 OR MA.Hidden IS NULL)
			ORDER BY pv.AverageRating DESC
		END
	ELSE
		BEGIN
		INSERT INTO #tempusrassets (MediaAssetID)
			SELECT TOP(@lastindex) MA.ID
			FROM dbo.MediaAsset MA WITH(NOLOCK) 
			INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
			LEFT JOIN dbo.PageVotes pv WITH(NOLOCK) ON AMA.entryid=pv.itemid/10 and pv.itemtype=1
			LEFT JOIN dbo.Votes v WITH(NOLOCK) ON pv.voteid=v.voteid and v.type=3
			WHERE MA.OwnerID = @userid
			AND (MA.Hidden <> 1 OR MA.Hidden IS NULL)
			ORDER BY MA.LastUpdated DESC
		END
	END
ELSE
	BEGIN
	IF @sortbycaption IS NOT NULL
		BEGIN
		INSERT INTO #tempusrassets (MediaAssetID)
			SELECT TOP(@lastindex) MA.ID
			FROM dbo.MediaAsset MA WITH(NOLOCK) 
			INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
			LEFT JOIN dbo.PageVotes pv WITH(NOLOCK) ON AMA.entryid=pv.itemid/10 and pv.itemtype=1
			LEFT JOIN dbo.Votes v WITH(NOLOCK) ON pv.voteid=v.voteid and v.type=3
			WHERE MA.OwnerID = @userid
			AND MA.Hidden IS NULL
			ORDER BY MA.Caption ASC
		END
	ELSE IF @sortbyrating IS NOT NULL
		BEGIN
		INSERT INTO #tempusrassets (MediaAssetID)
			SELECT TOP(@lastindex) MA.ID
			FROM dbo.MediaAsset MA WITH(NOLOCK) 
			INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
			LEFT JOIN dbo.PageVotes pv WITH(NOLOCK) ON AMA.entryid=pv.itemid/10 and pv.itemtype=1
			LEFT JOIN dbo.Votes v WITH(NOLOCK) ON pv.voteid=v.voteid and v.type=3
			WHERE MA.OwnerID = @userid
			AND MA.Hidden IS NULL
			ORDER BY pv.AverageRating DESC
		END
	ELSE
		BEGIN
		INSERT INTO #tempusrassets (MediaAssetID)
			SELECT TOP(@lastindex) MA.ID
			FROM dbo.MediaAsset MA WITH(NOLOCK) 
			INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
			LEFT JOIN dbo.PageVotes pv WITH(NOLOCK) ON AMA.entryid=pv.itemid/10 and pv.itemtype=1
			LEFT JOIN dbo.Votes v WITH(NOLOCK) ON pv.voteid=v.voteid and v.type=3
			WHERE MA.OwnerID = @userid
			AND MA.Hidden IS NULL
			ORDER BY MA.LastUpdated DESC
		END
	END
	

	--Remove entries not requested - skip and show.
	DELETE FROM #tempusrassets where id > @lastindex or id < @firstindex

--Get count.
select @count = count(*) from ( select * from #tempusrassets) as s

SELECT 	g.EntryID,
		g.h2g2ID, 
		g.subject,
		g.editor,
		g.extrainfo,
		g.datecreated,
		g.lastupdated,
		MA.ID,
		MA.ID As 'MediaAssetID',		
		MA.SiteID,
		MA.Caption,
		MA.Filename,
		MA.MimeType,
		MA.ContentType,
		MA.ExtraElementXML,
		MA.OwnerID,
		MA.DateCreated 'MADateCreated',
		MA.LastUpdated 'MALastUpdated',
		MA.Description,
		MA.Hidden,
		MA.ExternalLinkURL,
		@count 'count',
		@total 'total',
		pv.voteid CRPollID, pv.AverageRating CRAverageRating, pv.VoteCount CRVoteCount,	-- Content rating fields
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

FROM #tempusrassets tmp
INNER JOIN dbo.MediaAsset MA WITH(NOLOCK) ON MA.ID = tmp.MediaAssetID
INNER JOIN dbo.ArticleMediaAsset AMA WITH(NOLOCK) ON AMA.MediaAssetID = MA.ID
INNER JOIN dbo.GuideEntries g WITH(NOLOCK) ON g.EntryID = AMA.EntryID
INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = MA.OwnerID
LEFT JOIN dbo.ContentSignifUser csu  WITH(NOLOCK) ON u.Userid = csu.Userid AND csu.SiteID = MA.SiteID
LEFT JOIN dbo.PageVotes pv WITH(NOLOCK) on g.h2g2id=pv.itemid and pv.itemtype=1
LEFT JOIN dbo.Votes v WITH(NOLOCK) on pv.voteid=v.voteid and v.type=3
ORDER BY tmp.id
		
RETURN @@ERROR
END
