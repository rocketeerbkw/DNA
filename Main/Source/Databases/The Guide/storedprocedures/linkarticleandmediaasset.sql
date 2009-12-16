/*********************************************************************************

	create procedure linkarticleandmediaasset	@h2g2id int = 1, 
												@mediaassetid  int = 1

	Author:		Steven Francis
	Created:	18/11/2005
	Inputs:		h2g2ID - the article id
				MediaAssetID - the media asset id
	Outputs:	
	Returns:	bool if the link entry added ok
	Purpose:	Creates a record that links an article id to a media asset id
*********************************************************************************/
CREATE PROCEDURE linkarticleandmediaasset @h2g2id int, @mediaassetid int
AS

DECLARE @ErrorCode INT
DECLARE @EntryID INT

SELECT @EntryID = @h2g2id / 10

BEGIN TRANSACTION

INSERT INTO dbo.ArticleMediaAsset (EntryID, MediaAssetID) 
				VALUES (@EntryID, @mediaassetid)
IF (@ErrorCode <> 0)
BEGIN
	ROLLBACK TRANSACTION
	RETURN @ErrorCode
END
	
COMMIT TRANSACTION
