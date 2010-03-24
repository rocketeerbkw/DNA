/*
	inputs: @forumid = ID of journal forum
			@daysback = number of days to display
*/
Create Procedure forumlistjournalthreads @forumid int, @daysback int = NULL
As
	declare @datelimit datetime
	IF @daysback IS NULL
		SELECT Subject, DatePosted, EntryID, ThreadID, t.text FROM ThreadEntries t
			WHERE t.ForumID = @forumid 
				AND t.Parent IS NULL
			ORDER BY t.DatePosted DESC
	ELSE
	BEGIN
		SELECT @datelimit = DATEADD(day, 0-@daysback, getdate())
		SELECT Subject, DatePosted, EntryID, ThreadID, UserID, t.text FROM ThreadEntries t
			WHERE t.ForumID = @forumid 
				AND t.Parent IS NULL
				AND t.DatePosted >= @datelimit
			ORDER BY t.DatePosted DESC
	END
	return (0)