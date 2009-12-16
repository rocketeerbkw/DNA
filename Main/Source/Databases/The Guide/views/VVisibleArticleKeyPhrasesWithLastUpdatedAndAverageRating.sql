CREATE VIEW VVisibleArticleKeyPhrasesWithLastUpdatedAndAverageRating
WITH SCHEMABINDING
AS
	SELECT akp.SiteID,akp.EntryID,akp.PhraseNamespaceID,g.LastUpdated,pv.AverageRating
		FROM dbo.ArticleKeyPhrases akp
		INNER JOIN dbo.GuideEntries g ON g.EntryID=akp.EntryID
		INNER JOIN dbo.PageVotes pv ON g.EntryID = pv.itemid/10 and pv.itemtype=1
		WHERE g.Hidden IS NULL And g.Status != 7 AND g.Type < 1001		
GO
/*
CREATE UNIQUE CLUSTERED INDEX IX_VVisibleArticleKeyPhrasesWithLastUpdatedAndAverageRating
	ON VVisibleArticleKeyPhrasesWithLastUpdatedAndAverageRating(PhraseNamespaceID,AverageRating DESC,LastUpdated DESC,EntryID)
*/	
GO
