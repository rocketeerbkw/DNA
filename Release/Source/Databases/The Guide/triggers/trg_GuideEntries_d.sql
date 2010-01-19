CREATE TRIGGER trg_GuideEntries_d ON GuideEntries
FOR DELETE 
AS
	DELETE FROM ArticleIndex
	  FROM ArticleIndex ai
		   INNER JOIN deleted d ON d.EntryID = ai.EntryID

	DELETE FROM ArticleKeyPhrasesNonVisible
	  FROM ArticleKeyPhrasesNonVisible a
			INNER JOIN deleted d ON d.EntryID = a.EntryID

	DELETE FROM ArticleKeyPhrases
	  FROM ArticleKeyPhrases a
			INNER JOIN deleted d ON d.EntryID = a.EntryID