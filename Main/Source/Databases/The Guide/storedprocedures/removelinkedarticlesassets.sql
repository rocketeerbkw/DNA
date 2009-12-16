/*********************************************************************************

	create procedure removelinkedarticlesassets	@h2g2id int 
	Author:		Steven Francis
	Created:	30/11/2005
	Inputs:		h2g2ID - the article id
	Outputs:	
	Returns:	
	Purpose:	Removes the the mediaasset ids for a given article (h2g2id)
*********************************************************************************/
CREATE PROCEDURE removelinkedarticlesassets @h2g2id int
AS

DECLARE @ErrorCode INT
DECLARE @EntryID INT

SELECT @EntryID = @h2g2id / 10

DELETE FROM dbo.ArticleMediaAsset WHERE EntryID = @EntryID 

IF (@ErrorCode <> 0)
BEGIN
	RETURN @ErrorCode
END
