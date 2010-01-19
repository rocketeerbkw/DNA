CREATE VIEW VVisibleArticleKeyPhrasesWithLastUpdated
WITH SCHEMABINDING
AS
	SELECT akp.SiteID,akp.EntryID,akp.PhraseNamespaceID,g.LastUpdated
		FROM dbo.ArticleKeyPhrases akp
		INNER JOIN dbo.GuideEntries g ON g.EntryID=akp.EntryID
		WHERE g.Hidden IS NULL And g.Status != 7 AND g.Type < 1001
GO

-- No longer default search
--CREATE UNIQUE CLUSTERED INDEX IX_VVisibleArticleKeyPhrasesWithLastUpdated
--	ON VVisibleArticleKeyPhrasesWithLastUpdated(PhraseNamespaceID,LastUpdated DESC,EntryID)
GO