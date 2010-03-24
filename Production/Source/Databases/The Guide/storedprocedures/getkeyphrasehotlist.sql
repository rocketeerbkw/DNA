Create Procedure getkeyphrasehotlist @siteid int, @skip int = 0, @show int = 500, @sortbyphrase bit = null
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- Normalisation factor - phrase usage
DECLARE @maxphrasecount DECIMAL
SELECT @maxphrasecount=MAX(cnt) FROM VThreadKeyPhraseCounts WITH(NOEXPAND) WHERE SiteID=@siteid

--Normalisation factor - busiest conversations
DECLARE @maxscore DECIMAL
SELECT @maxscore = ISNULL(MAX(tmax.[score]),1.0)
FROM
(
	SELECT tkp.phraseid, SUM(cst.score) AS score 
		FROM ThreadKeyPhrases tkp
		INNER JOIN ContentSignifThread cst ON tkp.threadid= cst.threadid
		WHERE tkp.siteid=@siteid
		GROUP BY tkp.phraseid
) AS tmax;

--Create a Rank ( count of phrase usage + conversation activity score )
WITH RankedPhrases AS
(
	SELECT 0.6*(tk1.[count]/@maxphrasecount) + 0.4*(tt1.[score]/@maxscore) 'Rank',
					kk.Phrase,
					kk.PhraseId,
					'SortByPhrase' = CASE WHEN @sortbyphrase IS NOT NULL THEN Phrase ELSE NULL END
	FROM KeyPhrases kk WITH(NOLOCK)
	INNER JOIN (
		SELECT PhraseID, cnt/@maxphrasecount AS count 
		FROM VThreadKeyPhraseCounts WITH(NOEXPAND)
		WHERE SiteID = @siteid AND PhraseID NOT IN ( SELECT PhraseId FROM SiteKeyPhrases WHERE siteid = @siteid )
	) AS tk1 ON kk.PhraseId = tk1.PhraseId
	INNER JOIN (
		-- Score the threads associated wiht a phrase 
		select PhraseId, SUM(cst.Score) 'score'
		 from [dbo].ThreadKeyPhrases tk WITH(NOLOCK)
		 INNER JOIN [dbo].ContentSignifThread cst WITH(NOLOCK) ON cst.ThreadId = tk.ThreadId
		WHERE tk.siteid=@siteid
		 group by PhraseId
	) AS tt1 ON tt1.PhraseId = kk.PhraseId
),
OrderedPhrases AS
(
	SELECT rp.*,
			ROW_NUMBER() OVER(ORDER BY SortByPhrase ASC,Rank DESC) AS rn
	FROM RankedPhrases rp
)
SELECT (SELECT MAX(rn) AS count FROM OrderedPhrases) count,
		op.rank,
		op.Phrase
		FROM OrderedPhrases op
		WHERE rn > @skip AND rn <=(@skip+@show)
		ORDER BY op.SortByPhrase ASC, op.Rank DESC
