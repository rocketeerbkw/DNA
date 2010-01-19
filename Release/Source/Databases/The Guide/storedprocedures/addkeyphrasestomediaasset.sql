create procedure addkeyphrasestomediaasset @assetid INT, @keywords VARCHAR(8000)
AS

--Insert Phrase if it doesn't exist
INSERT INTO KeyPhrases(phrase) 
SELECT DISTINCT element FROM udf_splitvarchar(@keywords) u
WHERE NOT EXISTS ( SELECT kp.phrase FROM KeyPhrases kp WHERE kp.phrase = u.element )

--Tag Phrase to asset if it hasn't already been done.
INSERT INTO AssetKeyPhrases( phraseid, assetid) 
SELECT DISTINCT kp.phraseid, @assetid FROM udf_splitvarchar(@keywords) u
INNER JOIN KeyPhrases kp ON kp.phrase = u.element
WHERE NOT EXISTS ( 
	SELECT * From AssetKeyPhrases akp WHERE akp.PhraseId = kp.PhraseId AND akp.AssetId = @assetid )