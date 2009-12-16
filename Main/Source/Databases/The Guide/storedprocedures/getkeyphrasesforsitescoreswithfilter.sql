Create Procedure getkeyphrasesforsitescoreswithfilter  @keyphrases varchar(8000), @siteid int
AS

declare @count int
SELECT @count = count(*) FROM udf_splitvarchar(@keyphrases)

--Get a list of threads that are associated with one of @filterlist are are associated with all of @keyphraselist 
SELECT phrases.phrase, ISNULL(threadscores.score,0) 'score'
FROM SiteKeyPhrases skp
INNER JOIN KeyPhrases phrases ON phrases.PhraseId = skp.PhraseId
LEFT JOIN
(
	--Get the threads that are associated with a filter and the given phrase and score them.
	select thf.PhraseId, SUM(cst.Score) 'score'
	FROM ContentSignifThread cst
	INNER JOIN
	( 
		-- Get Threads that associated with the filter list.
		select ThreadID, skp.PhraseId  
			FROM SiteKeyPhrases skp
			INNER JOIN ThreadKeyPhrases tkp ON tkp.phraseid = skp.phraseid
	) AS thf ON thf.ThreadId = cst.ThreadId

	INNER JOIN
	(
		-- Get Threads that are associated with the given keyphrases.
		select ThreadID, count(kp.PhraseID) 'c' FROM udf_splitvarchar(@keyphrases) as s
			INNER JOIN KeyPhrases kp on kp.phrase = s.element
			INNER JOIN ThreadKeyPhrases tkp ON tkp.phraseid = kp.phraseid
			GROUP BY ThreadID 
			HAVING count(kp.PhraseID) = @count
	) AS thfilter ON thfilter.ThreadId = thf.ThreadId
	WHERE cst.SiteId = @siteid
	GROUP BY PhraseId
) AS threadscores ON threadscores.phraseId = phrases.PhraseId
	