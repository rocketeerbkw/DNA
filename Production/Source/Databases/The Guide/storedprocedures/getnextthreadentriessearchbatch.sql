CREATE Procedure getnextthreadentriessearchbatch @latestthreadentryid int, @siteid int, @previousmonths int 

As

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- If @latestthreadentryid and @previousmonths don't have values, the caller wants all posts
	-- so start from post 1
	IF (@latestthreadentryid <= 0 AND @previousmonths <= 0)
	BEGIN
		SET @latestthreadentryid = 1
	END

	-- new sites only
	-- Find a thread entry ID to start searching from
	WHILE @latestthreadentryid <= 0 AND @previousmonths < 48
	BEGIN
		-- Find a "day" range to hunt for a suitable starting EntryId
		DECLARE @startDate DATETIME, @endDate DATETIME
		SET @endDate =DATEADD(mm, @previousmonths * -1, GETDATE())
		SET @startDate =DATEADD(dd, -1, @endDate)

		SELECT @latestthreadentryid = ISNULL(MAX(te.EntryId),0)
		FROM dbo.ThreadEntries te WITH(INDEX=IX_ThreadEntries_DatePosted)
		WHERE te.DatePosted BETWEEN @startDate AND @endDate

		IF @latestthreadentryid <= 0
		BEGIN
			-- We didn't find an entry on that day, so have a look
			-- for posts that are a month older
			SET @previousmonths=@previousmonths+1
		END
	END

	DECLARE @urlname VARCHAR(30)
	SELECT @urlname=urlname FROM Sites WHERE SiteId=@siteid

	SELECT	'ThreadEntryID' = te.EntryID, 
			'SiteID' = t.SiteID, 
			'Subject' = te.Subject, 
			'Text' = te.Text,
			'DatePosted' = te.DatePosted,
			'URLName' = @urlname,
			'forumid' = t.forumid
	FROM dbo.Threads t
	INNER JOIN dbo.ThreadEntries te ON te.ThreadID = t.ThreadID
	WHERE te.EntryID > @latestthreadentryid
	and t.siteid=@siteid and te.hidden is null
	ORDER BY te.EntryID
	OPTION(OPTIMIZE FOR (@siteid=1)) -- Make sure the plan is suitable for busy sites
