Create Procedure removekeywords	@entryid int,
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
as
DELETE FROM GuideKeywords
WHERE EntryID = @entryid AND
(
	KeywordID = @kid1 OR
	KeywordID = @kid2 OR
	KeywordID = @kid3 OR
	KeywordID = @kid4 OR
	KeywordID = @kid5 OR
	KeywordID = @kid6 OR
	KeywordID = @kid7 OR
	KeywordID = @kid8 OR
	KeywordID = @kid9 OR
	KeywordID = @kid10 OR
	KeywordID = @kid11 OR
	KeywordID = @kid12 OR
	KeywordID = @kid13 OR
	KeywordID = @kid14 OR
	KeywordID = @kid15 OR
	KeywordID = @kid16
)
	return (0)