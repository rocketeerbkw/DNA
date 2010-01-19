/*********************************************************************************

	create procedure getftpuploadqueueforsite @siteid int 
	
	Author:		Steven Francis
	Created:	23/01/2006
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Calls the stored procedure to show the top 100 
				of the current upload queue for a site
	
*********************************************************************************/
CREATE PROCEDURE getftpuploadqueueforsite @siteid int 
AS
BEGIN

SELECT TOP 100 AssetID 'MediaAssetID', UploadStatus, MimeType, SiteID, Server
FROM dbo.MediaAssetUploadQueue WITH (NOLOCK)
WHERE SiteID = @siteid

END

