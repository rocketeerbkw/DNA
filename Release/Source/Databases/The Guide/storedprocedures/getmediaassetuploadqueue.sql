/*********************************************************************************

	create procedure getmediaassetuploadqueue server varchar(50)

	Author:		Steven Francis
	Created:	01/11/2005
	Inputs:		
	Outputs:	Returns the Assets that are idle (ie awaiting processing) dataset
	Purpose:	Get the assets for processing
	
*********************************************************************************/

CREATE PROCEDURE getmediaassetuploadqueue @server varchar(50) AS
	SELECT TOP 1 AssetID, MimeType, SiteID, Filename, InLibrary, SkipModeration
	FROM dbo.MediaAssetUploadQueue WITH(NOLOCK)
	WHERE UploadStatus = 1 AND Server = @server
	ORDER BY AssetID

