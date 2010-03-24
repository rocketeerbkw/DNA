CREATE PROCEDURE getkeyphrasesfrommediaasset @assetid INT
AS

select k.Phrase, ak.AssetId from [dbo].AssetKeyPhrases ak 
INNER JOIN [dbo].KeyPhrases k ON k.PhraseID = ak.PhraseID
where ak.assetid = @assetid

return @@error