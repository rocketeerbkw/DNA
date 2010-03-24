/*********************************************************************************

	create procedure removekeyphrasesfromassets	@id int, @phrases varchar(4096)
	Author:		Steven Francis
	Created:	30/01/2006
	Inputs:		id - the asset id
				phrases - comma delimited list of phrases
	Outputs:	
	Returns:	
	Purpose:	Removes the link to a key phrase from an asset
*********************************************************************************/
CREATE PROCEDURE removekeyphrasesfromassets @id int, @phrases varchar(4096)
AS

DELETE FROM dbo.AssetKeyPhrases 
WHERE AssetID = @id 
AND PhraseID IN 
(
	SELECT KP.PhraseID FROM udf_splitvarchar(@phrases) pn
	INNER JOIN dbo.KeyPhrases kp ON pn.element = kp.Phrase
)