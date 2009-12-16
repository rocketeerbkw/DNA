create procedure getkeyphrasesforsite @siteid INT
AS

select phrase from KeyPhrases kp
INNER JOIN sitekeyphrases skp ON skp.phraseId = kp.phraseId 
WHERE skp.SiteId = @siteid

RETURN @@ERROR