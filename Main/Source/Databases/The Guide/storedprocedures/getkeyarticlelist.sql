CREATE PROCEDURE getkeyarticlelist	@siteid int
As

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

IF @siteid > 0
BEGIN
SELECT k.ArticleName, k.EntryID, g.h2g2ID FROM KeyArticles k
	INNER JOIN GuideEntries g ON k.EntryID = g.EntryID
	WHERE k.DateActive <= getdate() AND k.SiteID = @siteid
		AND k.ArticleName <> 'xmlfrontpage'
		AND NOT EXISTS 
			(SELECT * FROM KeyArticles k1 
				WHERE (k1.DateActive <= getdate()) 
					AND (k1.DateActive > k.DateActive) 
					AND (k1.ArticleName = k.ArticleName)
					AND (k1.SiteID = k.SiteID))
	ORDER BY k.ArticleName, k.DateActive DESC
END
ELSE
BEGIN
-- If SiteID = 0 just return a distinct list of article names
select distinct ArticleName, SiteID from Keyarticles order by SiteID, articlename
END
