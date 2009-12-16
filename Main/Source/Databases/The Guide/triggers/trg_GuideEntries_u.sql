CREATE TRIGGER trg_GuideEntries_u ON GuideEntries
FOR UPDATE
AS
IF NOT UPDATE(LastUpdated)
BEGIN
	UPDATE GuideEntries SET LastUpdated = getdate() WHERE EntryID IN (SELECT EntryID FROM inserted)
END;

WITH EntriesToInsert AS
(
	SELECT i.EntryID, i.Subject, i.Status, i.SiteID FROM inserted i
		INNER JOIN deleted d ON i.EntryID = d.EntryID
		WHERE (d.Status NOT IN (1,3,4) OR LTRIM(d.Subject) = '' OR d.Hidden IS NOT NULL)
			AND (i.Status IN (1,3,4) AND LTRIM(i.Subject) <> '' AND i.Hidden IS NULL)
) 
INSERT INTO dbo.ArticleIndex (EntryID, Subject, SortSubject, IndexChar, UserID, Status, SiteID)
SELECT eti.EntryID, 
	   eti.Subject, 
	   dbo.udf_removegrammaticalarticlesfromtext (eti.Subject), 
	   CASE 
			WHEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (eti.Subject)),1) >= 'a' AND LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (eti.Subject)),1) <= 'z' THEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (eti.Subject)),1) 
			ELSE '.' END, 
	   m.UserID, 
	   eti.Status, 
	   eti.SiteID
  FROM EntriesToInsert AS eti
		LEFT JOIN Mastheads m on m.EntryID = eti.EntryID;

WITH EntriesToDelete AS
(
	SELECT i.EntryID FROM inserted i
		INNER JOIN deleted d ON i.EntryID = d.EntryID
		WHERE (i.Status NOT IN (1,3,4) OR LTRIM(i.Subject) = '' OR i.Hidden IS NOT NULL)
			AND (d.Status IN (1,3,4) AND LTRIM(d.Subject) <> '' AND d.Hidden IS NULL)
)
DELETE FROM ArticleIndex
  FROM ArticleIndex ai
	   INNER JOIN EntriesToDelete etd ON etd.EntryID = ai.EntryID;
	   
WITH EntriesToUpdate AS
(
	SELECT i.EntryID, i.Subject, i.Status, i.SiteID FROM inserted i
		INNER JOIN deleted d ON i.EntryID = d.EntryID
		WHERE (d.Status IN (1,3,4) AND LTRIM(d.Subject) <> '' AND d.Hidden IS NULL)
			AND (i.Status IN (1,3,4) AND LTRIM(i.Subject) <> '' AND i.Hidden IS NULL)
)
UPDATE ArticleIndex 
   SET UserID = m.UserID, 
	   Status = etu.Status,
	   SiteID = etu.SiteID
  FROM EntriesToUpdate etu
		LEFT JOIN Mastheads m on etu.EntryID = m.EntryID
 WHERE etu.EntryID = ArticleIndex.EntryID;

IF UPDATE(Subject)
BEGIN;
	WITH EntriesToUpdate AS
	(
		SELECT i.EntryID, i.Subject, i.Status, i.SiteID FROM inserted i
			INNER JOIN deleted d ON i.EntryID = d.EntryID
			WHERE (d.Status IN (1,3,4) AND LTRIM(d.Subject) <> '' AND d.Hidden IS NULL)
				AND (i.Status IN (1,3,4) AND LTRIM(i.Subject) <> '' AND i.Hidden IS NULL)
	)
	UPDATE ArticleIndex 
	   SET Subject = etu.Subject, 
		   SortSubject = dbo.udf_removegrammaticalarticlesfromtext (etu.Subject), 
		   IndexChar = CASE 
						WHEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (etu.Subject)),1) >= 'a' AND LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (etu.Subject)),1) <= 'z' THEN LEFT(LTRIM(dbo.udf_removegrammaticalarticlesfromtext (etu.Subject)),1) 
						ELSE '.' END
	  FROM EntriesToUpdate etu 
	 WHERE etu.EntryID = ArticleIndex.EntryID;
END;

WITH EntriesThatHaveJustBeenMadeNonVisible AS
(
	SELECT	i.EntryID
	  FROM	inserted i
			INNER JOIN deleted d ON i.EntryID = d.EntryID
	 WHERE	(d.Hidden IS NULL AND d.Status != 7) -- Visible
	   AND	(i.Hidden IS NOT NULL OR i.Status = 7) -- Not Visible
)
DELETE FROM dbo.ArticleKeyPhrases 
OUTPUT deleted.SiteID, deleted.EntryID, deleted.PhraseNamespaceID 
INTO dbo.ArticleKeyPhrasesNonVisible (SiteID, EntryID, PhraseNamespaceID)
FROM EntriesThatHaveJustBeenMadeNonVisible
WHERE ArticleKeyPhrases.EntryID = EntriesThatHaveJustBeenMadeNonVisible.EntryID;

WITH EntriesThatHaveJustBeenMadeVisible AS
(
	SELECT	i.EntryID
	  FROM	inserted i
			INNER JOIN deleted d ON i.EntryID = d.EntryID
	 WHERE	(d.Hidden IS NOT NULL OR d.Status = 7) -- Not Visible
	   AND	(i.Hidden IS NULL AND i.Status != 7) -- Visible
)
DELETE FROM dbo.ArticleKeyPhrasesNonVisible
OUTPUT deleted.SiteID, deleted.EntryID, deleted.PhraseNamespaceID 
INTO dbo.ArticleKeyPhrases (SiteID, EntryID, PhraseNamespaceID)
FROM EntriesThatHaveJustBeenMadeVisible
WHERE ArticleKeyPhrasesNonVisible.EntryID = EntriesThatHaveJustBeenMadeVisible.EntryID;