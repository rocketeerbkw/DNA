Create Procedure getkeywords @entryid int
As
SELECT k.KeywordID, k.KeywordName FROM Keywords k, GuideKeywords g WHERE g.KeywordID = k.KeywordID AND g.EntryID = @entryid
	return (0)