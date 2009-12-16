Create Procedure getuserpostingstats @userid int, @whichgroup int = 0, @numdays int = 7
As
	declare @before datetime, @after datetime, @now datetime
	SELECT @now = DATEADD(hour, 1, getdate())
	SELECT @before = DATEADD(day, @whichgroup * (0-@numdays), @now)
	SELECT @after = DATEADD(day, 0-@numdays, @before)
	DECLARE @newerpagedate datetime, @olderpagedate datetime
	SELECT @newerpagedate = MIN(DatePosted) 
		FROM ThreadEntries t 
		WHERE t.UserID = @userid AND DatePosted > @before

	SELECT @olderpagedate = MAX(DatePosted) 
		FROM ThreadEntries t 
		WHERE t.UserID = @userid AND DatePosted < @after

	declare @olderweek int, @newerweek int
	IF @newerpagedate IS NOT NULL
	BEGIN
		SELECT @newerweek = (DATEDIFF(day, @newerpagedate, @now)/7)
	END
	ELSE
	BEGIN
		SELECT @newerweek = NULL
	END
			
	IF @olderpagedate IS NOT NULL
	BEGIN
		SELECT @olderweek = (DATEDIFF(day, @olderpagedate, @now)/7)
	END
	ELSE
	BEGIN
		SELECT @olderweek = NULL
	END
			
	SELECT 'FromDate' = @after, 'ToDate' = @before, c.Cnt, c.ThreadID, t.FirstSubject, t.ForumID, u.UserName, c.MostRecent, 'NextGroup' = @newerweek, 'PrevGroup' = @olderweek
	FROM Threads t
	INNER JOIN (SELECT 'Cnt' = COUNT (*), ThreadID, 'MostRecent' = MAX(DatePosted) FROM ThreadEntries
	WHERE UserID = @userid AND DatePosted > @after AND DatePosted < @before
	GROUP BY ThreadID) AS c ON c.ThreadID = t.ThreadID
	INNER JOIN Users u ON u.UserID = @userid
	ORDER BY c.MostRecent DESC
	return (0)
