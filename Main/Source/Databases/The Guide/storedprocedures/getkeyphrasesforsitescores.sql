create procedure getkeyphrasesforsitescores @siteid INT --@keyphraselist VARCHAR(8000)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

-- get scoring for phrases provided - sum the score for each thread for each phrase.
SELECT SUM(ISNULL(cst.Score,0)) 'score', thf.Phrase
FROM
( 
	--Get Threads that have the given key phrases.
	select ThreadID,kp.Phrase  FROM SiteKeyPhrases s --udf_splitvarchar(@keyphraselist) as s
		INNER JOIN KeyPhrases kp on kp.phraseId = s.phraseId
		LEFT JOIN ThreadKeyPhrases tkp ON tkp.phraseid = kp.phraseid  
) AS thf

LEFT JOIN dbo.ContentSignifThread cst ON thf.ThreadId = cst.ThreadId AND cst.SiteId = @siteid
GROUP BY thf.Phrase

RETURN @@ERROR