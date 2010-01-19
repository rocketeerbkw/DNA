Create Procedure addkeywordstoentry @entryid int, 
								@kid1 int = NULL,
								@kid2 int = NULL,
								@kid3 int = NULL,
								@kid4 int = NULL,
								@kid5 int = NULL,
								@kid6 int = NULL,
								@kid7 int = NULL,
								@kid8 int = NULL,
								@kid9 int = NULL,
								@kid10 int = NULL,
								@kid11 int = NULL,
								@kid12 int = NULL,
								@kid13 int = NULL,
								@kid14 int = NULL,
								@kid15 int = NULL,
								@kid16 int = NULL
As
IF @kid1 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid1)
IF @kid2 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid2)
IF @kid3 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid3)
IF @kid4 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid4)
IF @kid5 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid5)
IF @kid6 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid6)
IF @kid7 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid7)
IF @kid8 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid8)
IF @kid9 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid9)
IF @kid10 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid10)
IF @kid11 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid11)
IF @kid12 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid12)
IF @kid13 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid13)
IF @kid14 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid14)
IF @kid15 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid15)
IF @kid16 IS NOT NULL
	INSERT INTO GuideKeywords (EntryID, KeywordID) VALUES (@entryid, @kid16)

	return (0)