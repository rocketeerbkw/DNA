/*********************************************************************************

	create procedure reprocessfaileduploads @siteid int

	Author:		Steven Francis
	Created:	10/02/2006
	Inputs:		Site ID, Media Asset ID
	Outputs:	
	Purpose:	Resets the upload status for the failed items in the 
				upload queue so an attempt is made to reprocess
	
*********************************************************************************/

CREATE PROCEDURE reprocessfaileduploads @siteid int, @mediaassetid int = null AS

IF @mediaassetid IS NULL
BEGIN
	UPDATE dbo.MediaAssetUploadQueue SET UploadStatus = 1 
	WHERE UploadStatus = 3 AND SiteID = @siteid
END
ELSE
BEGIN
	UPDATE dbo.MediaAssetUploadQueue SET UploadStatus = 1 
	WHERE UploadStatus = 3 AND SiteID = @siteid AND AssetID = @mediaassetid
END


