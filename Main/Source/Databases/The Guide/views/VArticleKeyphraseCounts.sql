CREATE VIEW VArticleKeyphraseCounts WITH SCHEMABINDING
AS
SELECT akp.siteid,
	kp.phraseID,
	count_big(*) cnt
	FROM dbo.ArticleKeyPhrases akp
		INNER JOIN dbo.PhraseNameSpaces pns ON akp.PhraseNameSpaceID = pns.PhraseNameSpaceID
		INNER JOIN dbo.KeyPhrases kp ON pns.PhraseId = kp.PhraseId
	WHERE pns.NameSpaceID IS NULL -- for the first step in namespace migration only 'old' phrases will be seleted i.e. those without a namespace
	GROUP BY akp.siteid,kp.phraseID

GO

CREATE UNIQUE CLUSTERED INDEX IX_VArticleKeyphraseCounts ON VArticleKeyphraseCounts
(
	siteid ASC,
	phraseID ASC
)

GO