/*********************************************************************************

	create procedure getvideoasset @mediaassetid int as

	Author:		Steven Francis
	Created:	07/11/2005
	Inputs:		@MediaAssetID - ID of Media Asset to load
	Outputs:	Returns the Asset dataset
	Purpose:	Get the details of an asset
	
*********************************************************************************/

CREATE PROCEDURE getvideoasset @mediaassetid int AS
	SELECT 		M.ID,
				M.ID As 'MediaAssetID',
				M.SiteID,
				M.Caption,
				M.Filename,
				M.MimeType,
				M.ContentType,
				M.ExtraElementXML,
				M.OwnerID,
				M.DateCreated,
				M.LastUpdated,
				M.DateCreated AS 'MADateCreated',
				M.LastUpdated AS 'MALastUpdated',
				M.Description,
				M.Hidden, 
				M.ExternalLinkURL,
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
 
	FROM dbo.VideoAssets AS V WITH(NOLOCK) 
	INNER JOIN dbo.MediaAsset AS M WITH(NOLOCK) ON V.MediaAssetID = M.ID
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = M.OwnerID
	LEFT JOIN dbo.ContentSignifUser csu  WITH(NOLOCK) ON u.Userid = csu.Userid AND csu.SiteID = M.SiteID
	WHERE M.ID = @mediaassetid
