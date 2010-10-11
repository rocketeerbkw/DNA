CREATE Procedure getnextthreadentriessearchbatch @latestthreadentryid int, @siteid int, @previousmonths int 

As

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SELECT 'ThreadEntryID' = te.EntryID, 
		'SiteID' = t.SiteID, 
		'Subject' = lower(te.Subject), 
		'Text' = lower(te.Text),
		'DatePosted' = te.DatePosted,
		'URLName' = s.URLName,
		'forumid' = t.forumid
		FROM Threads t
	INNER JOIN ThreadEntries te ON te.ThreadID = t.ThreadID
	INNER JOIN Sites s ON s.SiteID = t.SiteID
	WHERE te.EntryID > @latestthreadentryid
	and s.siteid=@siteid
	and (@latestthreadentryid >0 or @previousmonths = 0 or te.DatePosted > dateadd(mm, @previousmonths * -1, getdate()))--new sites only
	and (te.hidden is null)
	ORDER BY te.EntryID 

