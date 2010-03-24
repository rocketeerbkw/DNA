/*********************************************************************************

	create procedure getkeyphrasearticlehotlistwithphrase @keyphraselist VARCHAR(8000), @siteid int, @firstindex int, @lastindex int as

	Author:		Steven Francis
	Created:	16/12/2005
	Inputs:		siteid, 
				phrases filter - hot list will be based on articles that are associated with these phrases
				skp & show params 
				ssortByParam - sort by rank ( default ) or sort by phrase.
	Outputs:	
	Purpose:	Get a tag cloud based on the provided site and phrases filter.
	
*********************************************************************************/
Create Procedure getkeyphrasearticlehotlistwithphrase @siteid int, @keyphraselist VARCHAR(500), @skip int = 0, @show int = 500, @sortbyphrase bit = null
AS

-- BODGE!
-- If site is 606, return.  This code will go once a site option is coded
if @siteid = 67
BEGIN
	return
END

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- Use a temp table to give the optimiser statistical data on the likely number of phrases passed in
SELECT DISTINCT kp.phraseid, kp.phrase INTO #Phrases
	FROM dbo.udf_splitvarchar(@keyphraselist) p
	INNER JOIN KeyPhrases kp on kp.phrase = p.element;

-- @max is count of the most frequently used phrase on the site
DECLARE @max int
SELECT @max = max(cnt) FROM VArticleKeyphraseCounts v WITH(NOEXPAND) WHERE siteid=@siteid;


WITH MatchedEntries AS
(
	-- All the entries that have the phrases passed in
	select akp.EntryID 
		FROM #Phrases p
		INNER JOIN dbo.PhraseNameSpaces pns WITH(NOLOCK) ON p.phraseid = pns.PhraseID
		INNER JOIN dbo.ArticleKeyPhrases akp ON  pns.PhraseNameSpaceID = akp.PhraseNameSpaceID AND akp.siteid=@siteid
		INNER JOIN dbo.VVisibleGuideEntries g ON g.entryid=akp.entryid AND g.siteid = @siteid 
		WHERE pns.NameSpaceID IS NULL -- for the first step in namespace migration only 'old' phrases will be seleted i.e. those without a namespace
),
AssocPhrases AS
(
	-- All the phrases associated with all the matched entries
	-- excluding the phrases passed in
	SELECT DISTINCT kp.PhraseID
		FROM MatchedEntries me
		INNER JOIN ArticleKeyPhrases akp on akp.entryid = me.entryid
		INNER JOIN dbo.PhraseNameSpaces pns WITH(NOLOCK) ON akp.PhraseNameSpaceID = pns.PhraseNameSpaceID
		INNER JOIN dbo.KeyPhrases kp ON pns.PhraseID = kp.PhraseID
		WHERE kp.phraseid NOT IN (SELECT PhraseID FROM #Phrases)
		AND pns.NameSpaceID IS NULL -- for the first step in namespace migration only 'old' phrases will be seleted i.e. those without a namespace
),
Ordered AS
(
	-- Each phrase id is given a row number based their count
	SELECT	ap.phraseid,
			v.cnt,
			ROW_NUMBER() OVER(ORDER BY v.cnt DESC) rn
		FROM AssocPhrases ap
		INNER JOIN VArticleKeyphraseCounts v WITH(NOEXPAND) on v.phraseid = ap.phraseid AND v.siteid=@siteid
),
Counted AS
(
	-- Count the number of phrases we have
	SELECT	o.*,
			max(rn) OVER() AS 'count'
		FROM Ordered o
)
SELECT	CAST(c.count As INT) As 'Count',
		CAST(cnt AS FLOAT)/CAST(@max AS FLOAT) 'rank',
		kp.phrase,
		kp.phraseid,
		'SortByPhrase' = CASE WHEN @sortbyphrase IS NOT NULL THEN kp.Phrase ELSE NULL END
	FROM Counted c
		INNER JOIN KeyPhrases kp ON kp.phraseid=c.phraseid
		WHERE rn >@skip AND rn<=(@skip+@show)
		ORDER BY SortByPhrase, rn
