/*********************************************************************************

	create procedure getarticlesassets	@h2g2id int = 1
	Author:		Steven Francis
	Created:	18/11/2005
	Inputs:		h2g2ID - the article id
	Outputs:	
	Returns:	Media Asset ids dataset
	Purpose:	Gets the the mediaasset ids for a given article (h2g2id)
*********************************************************************************/
CREATE PROCEDURE getarticlesassets @h2g2id int
AS

DECLARE @ErrorCode INT
DECLARE @EntryID INT

SELECT @EntryID = @h2g2id / 10

SELECT am.MediaAssetID, ma.MimeType, ma.Hidden 
FROM dbo.ArticleMediaAsset am WITH (NOLOCK)
INNER JOIN MediaAsset ma WITH (NOLOCK) ON ma.Id = am.MediaAssetID
WHERE EntryID = @EntryID 
IF (@ErrorCode <> 0)
BEGIN
	RETURN @ErrorCode
END
