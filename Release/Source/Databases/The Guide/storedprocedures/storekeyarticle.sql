Create Procedure storekeyarticle	@articlename varchar(255), @entryid int, @activate datetime = NULL, @siteid int = NULL
As
	if @activate IS NULL
		SELECT @activate = getdate()
	INSERT INTO KeyArticles (ArticleName, EntryID, DateActive, SiteID) VALUES (@articlename, @entryid, @activate, @siteid)
	return (0)