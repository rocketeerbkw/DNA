Create Procedure getkeyarticle @articlename varchar(255)
As
	SELECT k.ArticleName, g.text FROM KeyArticles k, GuideEntries g WHERE k.ArticleName = @articlename AND g.EntryID = k.EntryID

	return (0)