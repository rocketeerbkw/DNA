Create Procedure getwappostdetails @threadid int, @postid int = NULL
As
declare @nextpost int, @prevpost int, @postdate datetime
	if @postid IS NULL
	BEGIN
		SELECT TOP 1 @postid = EntryID, @postdate = DatePosted FROM ThreadEntries
			WHERE ThreadID = @threadid ORDER BY DatePosted
	END
	ELSE
	BEGIN
		SELECT @postdate = DatePosted FROM ThreadEntries
			WHERE EntryID = @postid
	END

	SELECT TOP 1 @nextpost = EntryID FROM ThreadEntries
		WHERE DatePosted > @postdate AND ThreadID = @threadid
			ORDER BY DatePosted
	SELECT TOP 1 @prevpost = EntryID FROM ThreadEntries
		WHERE DatePosted < @postdate AND ThreadID = @threadid
			ORDER BY DatePosted DESC

	SELECT TOP 1 'Prev' = @prevpost, 'Next' = @nextpost, Subject, u.UserName, EntryID, DatePosted, t.ForumID, f.JournalOwner, t.text 
		FROM ThreadEntries t, Users u, Forums f
		WHERE u.UserID = t.UserID 
			AND t.ThreadID = @threadid
			AND f.ForumID = t.ForumID
			AND t.EntryID = @postid

	return (0)