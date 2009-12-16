/*********************************************************************************

	create procedure getftpuploadqueue 
	
	Author:		Steven Francis
	Created:	23/01/2006
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Calls the stored procedure to show the the top 100 
				of the current upload queue
	
*********************************************************************************/
CREATE PROCEDURE getftpuploadqueue 
AS
BEGIN

SELECT TOP 100 AssetID 'MediaAssetID', UploadStatus, MimeType, SiteID, Server
FROM dbo.MediaAssetUploadQueue WITH (NOLOCK)

END

