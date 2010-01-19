CREATE VIEW VThreadKeyphraseCounts WITH SCHEMABINDING
AS
SELECT tkp.siteid,
	tkp.phraseID,
	count_big(*) cnt
	FROM dbo.ThreadKeyPhrases tkp
	GROUP BY tkp.siteid,tkp.phraseID

GO

CREATE UNIQUE CLUSTERED INDEX IX_VThreadKeyphraseCounts ON VThreadKeyphraseCounts
(
	siteid ASC,
	phraseID ASC
)

GO