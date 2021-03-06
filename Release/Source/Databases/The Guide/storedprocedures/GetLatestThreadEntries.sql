CREATE PROCEDURE getlatestthreadentries
AS

	DECLARE @latestThreadEntryID int
	--Get the DNASearch DBs latest threadEntry
	
	
	DECLARE @server nvarchar(255);
	DECLARE @database nvarchar(255);
	
	--Get the 'other' DB config
	SELECT @server = server, @database = [database] FROM DatabaseConfig
	
	IF NOT EXISTS ( SELECT * FROM sys.servers WHERE name = @server )
	BEGIN
		PRINT 'Create Link Server' + @server
		--exec createlinkedserver @server, @database
	END
	
	PRINT 'Create New Sites'
	
	CREATE TABLE #tempThreadEntries(ThreadEntryID int NOT NULL PRIMARY KEY, 
								SiteID int,
								subject nvarchar(255) NULL,
								[text] nvarchar(MAX) NULL,
								DatePosted datetime NOT NULL,
								URLName nvarchar(30) NULL,
								ForumID int not null)
	DECLARE @sql nvarchar(MAX)
	
	--Work out if there are any new sites in the new batch
	DECLARE NewSites_Cursor CURSOR FAST_FORWARD FOR

	SELECT DISTINCT SiteID, MonthsToRetain FROM searchsites
	DECLARE @SiteID int
	DECLARE @MonthsToRetain int
	OPEN NewSites_Cursor 

	FETCH NEXT FROM NewSites_Cursor 
	INTO @SiteID, @MonthsToRetain

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Retrieving for SiteID ' + CAST(@SiteID AS nvarchar(10))
		
		SELECT @latestThreadEntryID = ISNULL(MAX(ThreadEntryID),0) FROM SearchThreadEntries where siteid = @SiteID 

		-- note add server to query for linked server on other machine.
		set @sql='exec [' + @server + '].' + @database + '.dbo.getnextthreadentriessearchbatch @latestthreadentryid=' + CAST(@latestThreadEntryID AS nvarchar) + ', @siteid=' +  CAST(@siteid AS nvarchar) + ', @previousmonths=' +  CAST(@MonthsToRetain AS nvarchar)
		PRINT @sql

		INSERT #tempThreadEntries exec(@sql)



		PRINT 'Removing older posts'--delete older posts from table
		if @MonthsToRetain > 0
		BEGIN
			delete from dbo.SearchThreadEntries
			where siteid = @siteid
			and DatePosted < dateadd(mm, @MonthsToRetain * -1, getdate())
		END
		
		
		FETCH NEXT FROM NewSites_Cursor 
		INTO @SiteID, @MonthsToRetain
	END
	CLOSE NewSites_Cursor 
	DEALLOCATE NewSites_Cursor 

	
	DECLARE @numEntries INT
	SELECT @numEntries=count(*) from #tempThreadEntries
	PRINT 'Num rows to copy: '+cast(@numEntries as varchar)

	DECLARE NewRows_Cursor CURSOR FAST_FORWARD FOR
		SELECT ThreadEntryID, SiteID, subject, [text], DatePosted, ForumID FROM #tempThreadEntries

	DECLARE @ThreadEntryID int, @ForumID int, @n int
	DECLARE @subject nvarchar(max), @text nvarchar(max), @DatePosted DateTime

	OPEN NewRows_Cursor 

	FETCH NEXT FROM NewRows_Cursor 
		INTO @ThreadEntryID, @SiteID, @subject, @text, @DatePosted, @ForumID

	SET @n=1
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO dbo.SearchThreadEntries (ThreadEntryID, SiteID, subject, [text], DatePosted, ForumID) 
			SELECT @ThreadEntryID, @SiteID, @subject, @text, @DatePosted, @ForumID

		PRINT 'Inserted row '+cast(@n as varchar)
		SET @n=@n+1
		FETCH NEXT FROM NewRows_Cursor 
			INTO @ThreadEntryID, @SiteID, @subject, @text, @DatePosted, @ForumID
	END
	CLOSE NewRows_Cursor 
	DEALLOCATE NewRows_Cursor 

	DROP TABLE #tempThreadEntries

