CREATE Procedure performsearch	@userid int,
									@contains varchar(1024),
									@forumposts int,
									@userpages int,
									@guideentries int,
									@submitted int
As
	declare @condition varchar(2048), @statlist varchar(255)
	--SELECT @contains = QUOTENAME(@contains,'''')
	--select 'EntryID' = g.EntryID, 'PostID' = t.EntryID, 'Subject' = g.Subject, 'PostSubject' = t.Subject, 'ThreadID' = t.ThreadID, 'ForumID' = t.ForumID, 'h2g2ID' = g.h2g2ID, g.Status from blobs b LEFT JOIN GuideEntries g ON g.blobid = b.blobid LEFT JOIN ThreadEntries t ON t.blobid = b.blobid where (CONTAINS(b.text, '$contains') OR CONTAINS(g.Subject, '$contains')) AND (t.Hidden <> 1 OR t.Hidden IS NULL) AND (g.Status IN (3,4,5,6,1) OR g.Status IS NULL)

	IF @userpages = 1
	BEGIN
		SELECT @statlist = '3,4,5,6,'
	END
	IF @guideentries = 1
	BEGIN
		SELECT @statlist = @statlist + '1,'
	END
	IF @submitted = 1
	BEGIN
		SELECT @statlist = @statlist + '4,'
	END

	IF LEN(@statlist) > 0
	BEGIN
		SELECT @statlist = LEFT(@statlist, LEN(@statlist)-1)
		SELECT @statlist = '(' + @statlist + ')'
	END

	if @forumposts = 1
	BEGIN
		-- we're looking for posts, and possibly pages as well
		if LEN(@statlist) > 0
		BEGIN
			-- both posts and pages - construct suitable SQL
			
			SELECT @condition = 'select g.EntryID, t.EntryID, g.Subject, t.Subject, t.ThreadID, t.ForumID, g.h2g2ID, g.Status from blobs b LEFT JOIN GuideEntries g ON g.blobid = b.blobid LEFT JOIN ThreadEntries t ON t.blobid = b.blobid where (CONTAINS(b.text, ''' + @contains + ''') OR CONTAINS(g.Subject, ''' + @contains + ''')) AND (t.Hidden IS NULL) AND (g.Status IN ' + @statlist + ' OR g.Status IS NULL)'
		END
		else
		BEGIN
			SELECT @condition = 'select NULL, t.EntryID, NULL, t.Subject, t.ThreadID, t.ForumID, NULL, NULL from blobs b LEFT JOIN ThreadEntries t ON t.blobid = b.blobid where CONTAINS(b.text, ''' + @contains + ''') AND (t.Hidden IS NULL) AND (t.EntryID IS NOT NULL)'
		END
	END
	else
	BEGIN
		if (LEN(@statlist) > 0)
		BEGIN
			SELECT @condition = 'select g.EntryID, NULL, g.Subject, NULL, NULL, NULL, g.h2g2ID, g.Status from blobs b LEFT JOIN GuideEntries g ON g.blobid = b.blobid where (CONTAINS(b.text, ''' + @contains + ''') OR CONTAINS(g.Subject, ''' + @contains + ''')) AND (g.Status IN ' + @statlist + ' OR g.Status IS NULL) AND g.EntryID IS NOT NULL'
		END
		else
		BEGIN
			-- oops - no buttons selected! Just find everything
			SELECT @condition = 'select g.EntryID, t.EntryID, g.Subject, t.Subject, t.ThreadID, t.ForumID, g.h2g2ID, g.Status from blobs b LEFT JOIN GuideEntries g ON g.blobid = b.blobid LEFT JOIN ThreadEntries t ON t.blobid = b.blobid where (CONTAINS(b.text, ''' + @contains + ''') OR CONTAINS(g.Subject, ''' + @contains + ''')) AND (t.Hidden IS NULL) AND (g.Status IN (3,4,5,6,1) OR g.Status IS NULL)'
		END
	END

	print @condition

	return (0)
