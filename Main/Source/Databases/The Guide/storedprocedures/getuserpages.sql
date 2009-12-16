Create Procedure getuserpages @userid int, @status int, @whichgroup int = 0, @numdays int = 7
As
	declare @before datetime, @after datetime, @now datetime
	SELECT @now = DATEADD(hour, 1, getdate())
	SELECT @before = DATEADD(day, @whichgroup * (0-@numdays), @now)
	SELECT @after = DATEADD(day, 0-@numdays, @before)
	DECLARE @newerpagedate datetime, @olderpagedate datetime
	SELECT @newerpagedate = MIN(DateCreated) 
		FROM GuideEntries g 
		INNER JOIN Researchers r ON r.EntryID = g.EntryID
		WHERE (r.UserID = @userid OR g.Editor = @userid) AND DateCreated > @before AND g.Status = @status

	SELECT @olderpagedate = MAX(DateCreated) 
		FROM GuideEntries g 
		INNER JOIN Researchers r ON r.EntryID = g.EntryID
		WHERE (r.UserID = @userid OR g.Editor = @userid) AND DateCreated < @after AND g.Status = @status

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
			
	SELECT 'FromDate' = @after, 'ToDate' = @before, g.Subject, g.h2g2ID,g.DateCreated, u.UserName, 'NextGroup' = @newerweek, 'PrevGroup' = @olderweek
	FROM GuideEntries g
		INNER JOIN Researchers r ON r.EntryID = g.EntryID
		INNER JOIN Users u ON u.UserID = @userid
	WHERE (g.Editor = @userid OR r.UserID = @userid) AND DateCreated > @after AND DateCreated < @before AND g.Status = @status
	ORDER BY DateCreated DESC
	return (0)
