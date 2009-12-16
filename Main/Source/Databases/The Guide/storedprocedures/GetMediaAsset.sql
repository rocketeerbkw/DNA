/*********************************************************************************

	create procedure getmediaasset @mediaassetid int as

	Author:		Steven Francis
	Created:	17/10/2005
	Inputs:		@mediaassetid - ID of Asset to load
	Outputs:	Returns the Asset dataset
	Purpose:	Get the details of an asset
	
*********************************************************************************/

CREATE PROCEDURE getmediaasset @mediaassetid int AS
	SELECT 		MA.ID,
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
				
	FROM dbo.MediaAsset MA WITH(NOLOCK)
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = MA.OwnerID
	LEFT JOIN dbo.ContentSignifUser csu WITH(NOLOCK) ON u.Userid = csu.Userid AND csu.SiteID = MA.SiteID
	WHERE MA.ID = @mediaassetid