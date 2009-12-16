CREATE VIEW VVisibleArticleKeyPhrasesWithDateCreated
WITH SCHEMABINDING
AS
	SELECT akp.SiteID,akp.EntryID,akp.PhraseNamespaceID,g.DateCreated
		FROM dbo.ArticleKeyPhrases akp
		INNER JOIN dbo.GuideEntries g ON g.EntryID=akp.EntryID
		WHERE g.Hidden IS NULL And g.Status != 7 AND g.Type < 1001
GO

CREATE UNIQUE CLUSTERED INDEX IX_VVisibleArticleKeyPhrasesWithDateCreated
	ON VVisibleArticleKeyPhrasesWithDateCreated(PhraseNamespaceID,DateCreated DESC,EntryID)
GO