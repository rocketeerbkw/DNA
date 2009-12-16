/*********************************************************************************

	create procedure removeallkeyphrasesfromasset	@id int
	Author:		Steven Francis
	Created:	19/06/2006
	Inputs:		id - the asset id
	Outputs:	
	Returns:	
	Purpose:	Removes all the links to key phrases from an asset
*********************************************************************************/
CREATE PROCEDURE removeallkeyphrasesfromasset @id int
AS

DELETE FROM dbo.AssetKeyPhrases 
WHERE AssetID = @id 