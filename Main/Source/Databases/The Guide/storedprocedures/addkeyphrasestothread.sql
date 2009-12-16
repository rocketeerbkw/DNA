create procedure addkeyphrasestothread @threadid INT, @keywords VARCHAR(8000)
AS

--Insert Phrase if it doesn't exist
INSERT INTO KeyPhrases(phrase) 
SELECT DISTINCT element FROM udf_splitvarchar(@keywords) u
WHERE NOT EXISTS ( SELECT kp.phrase FROM KeyPhrases kp WHERE kp.phrase = u.element )

DECLARE @siteid INT
SELECT @siteid=t.SiteID
	FROM Threads t
	WHERE t.ThreadID=@threadid

--Tag Phrase to thread if it hasn't already been done.
INSERT INTO ThreadKeyPhrases(SiteID, phraseid,threadid) 
SELECT DISTINCT @siteid, kp.phraseid, @threadid FROM udf_splitvarchar(@keywords) u
INNER JOIN KeyPhrases kp ON kp.phrase = u.element
WHERE NOT EXISTS ( 
	SELECT * From ThreadKeyPhrases tkp WHERE tkp.PhraseId = kp.PhraseId AND tkp.ThreadId = @threadid )
