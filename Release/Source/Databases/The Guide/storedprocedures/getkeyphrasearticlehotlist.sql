/*********************************************************************************

	create procedure getkeyphrasearticlehotlist @keyphraselist VARCHAR(8000), @siteid int, @firstindex int, @lastindex int, @sortbyphrase bit = null as

	Author:		Steven Francis
	Created:	16/12/2005
	Inputs:		siteid, 
				phrases filter - hot list will be based on articles that are associated with these phrases
				skp & show params 
				ssortByParam - sort by rank ( default ) or sort by phrase.
	Outputs:	
	Purpose:	Get a tag cloud based on the provided site and phrases filter.
	
*********************************************************************************/
CREATE PROCEDURE getkeyphrasearticlehotlist @siteid int, @skip int = 0, @show int = 500, @sortbyphrase bit = null
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @max INT
SELECT @max=MAX(cnt) FROM VArticleKeyphraseCounts WHERE SiteID=@siteid;

WITH Ranked AS
(
	SELECT  vakp.PhraseID,
			vakp.cnt,
			ROW_NUMBER() OVER(ORDER BY vakp.cnt DESC) rn
		FROM VArticleKeyphraseCounts vakp WITH(NOEXPAND) 
		WHERE vakp.SiteID=@siteid
),
Trimmed AS
(
	SELECT * FROM Ranked
	WHERE rn > @skip AND rn <=(@skip+@show)
)
SELECT  kp.Phrase,
		CAST((t.cnt*1.0 / @max) AS Float) 'Rank',
		(SELECT count(*) FROM Trimmed) Count,
		(SELECT count(*) FROM Ranked) 'Total Phrases'
		FROM Trimmed t
		INNER JOIN KeyPhrases kp ON kp.PhraseID = t.PhraseID
	ORDER BY t.rn

RETURN @@ERROR

